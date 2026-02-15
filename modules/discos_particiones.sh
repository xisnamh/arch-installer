while true; do
	# --- PASO 1 Y 2: SELECCION DE DISCO ---
	while true; do
		menu_header
		print_title "GESTION DE DISCOS"

		printf "${blue}Discos detectados en el sistema:${end}\n"
		lsblk -p -n -l -o NAME,SIZE,TYPE | grep "disk"
		printf "\n"

		printf "${yellow}Escribe la ruta del disco (ej: /dev/nvme0n1): ${end}"
		read DISCO

		if [ -z "$DISCO" ]; then
			printf "${red}[!] No has escrito nada.${end}"
			sleep $T_ERR
		elif [ -b "$DISCO" ]; then
			printf "${green}[+] Disco seleccionado correctamente: $DISCO${end}\n"
			sleep $T_INFO
			break
		else
			printf "${red}[!] El dispositivo '$DISCO' no existe o no es valido.${end}"
			sleep $T_ERR
		fi
	done

	# --- PASO 3: MENU DE ACCIONES ---
	VOLVER_AL_PASO_1=false

	while true; do
		menu_header
		print_title "DISCO SELECCIONADO: $DISCO"
		printf "Selecciona la operacion:\n"
		printf " 1) Ver salud/info (SMART/NVMe)\n"
		printf " 2) Borrado de fabrica (NVMe Sanitize)\n"
		printf " 3) Limpiar firmas y tablas (wipefs/zap-all)\n"
		printf " 4) Particionar con cfdisk\n"
		printf " 5) Volver atras (Cambiar de disco)\n"
		printf " 6) Finalizar y continuar\n"

		pregunta
		read disco_opt

		case $disco_opt in
			1)
				if [[ "$DISCO" == *"nvme"* ]]; then
					pacman -S --needed nvme-cli --noconfirm
					nvme smart-log "$DISCO"
				else
					pacman -S --needed smartmontools --noconfirm
					smartctl -a "$DISCO"
				fi
				pausa
				;;
			2)
				if [[ "$DISCO" == *"nvme"* ]]; then
					printf "${red}ADVERTENCIA: Borrado fisico.${end}\n"
					printf "¿Confirmar? (escribe 'BORRAR'): "
					read confirm
					if [ "$confirm" == "BORRAR" ]; then
						pacman -S --needed nvme-cli --noconfirm
						nvme sanitize "$DISCO" --sanact=3
					fi
				fi
				pausa
				;;
			3)
				printf "${red}[!] Limpiando tablas de particiones en $DISCO...${end}\n"
				pacman -S --needed gptfdisk --noconfirm
				wipefs -a "$DISCO"
				sgdisk --zap-all "$DISCO"
				printf "${green}[+] Disco limpio.${end}\n"
				pausa
				;;
			4)
				cfdisk "$DISCO"
				;;
			5)
				VOLVER_AL_PASO_1=true
				break
				;;
			6)
				menu_header
				print_title "RESUMEN FINAL"
				lsblk "$DISCO"
				printf "\n¿Todo listo para continuar? (s/n): "
				read final_conf
				if [[ "$final_conf" == [Ss] ]]; then
					break 2
				fi
				;;
			*)
				printf "${red}[!] Opcion no valida.${end}\n"
				sleep $T_ERR
				;;
		esac
	done

	if [ "$VOLVER_AL_PASO_1" = false ]; then
		break
	fi
done
