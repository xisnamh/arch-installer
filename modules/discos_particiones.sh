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
		
		# Mostramos detalles específicos del disco elegido
		printf "${blue}Detalles del dispositivo:${end}\n"
		if [ "$IS_VM" = true ]; then
			# En VM nos interesa saber el VENDOR (VBOX, VMware) y el tipo de transporte
			lsblk -p -o NAME,SIZE,TYPE,MODEL,VENDOR,TRAN | grep -E "NAME|$DISCO" | column -t
		else
			# En físico nos interesa más el modelo real y si es SSD/HDD
			lsblk -p -o NAME,SIZE,TYPE,MODEL,ROTA,TRAN | grep -E "NAME|$DISCO" | column -t
		fi
		printf "\n"
		
		printf "Selecciona la operacion:\n"
		printf " 1) Ver salud/info (SMART/NVMe)\n"
		printf " 2) Borrado de fabrica (NVMe Sanitize)\n"
		printf " 3) Limpiar firmas y tablas (wipefs/zap-all)\n"
		printf " 4) Particionar con cfdisk\n"
		printf " 5) Volver atras\n"
		printf " 6) Finalizar y continuar\n"

		pregunta
		read disco_opt

		case $disco_opt in
			1)
				if [[ "$DISCO" == *"nvme"* ]]; then
					# Instalamos silenciosamente redireccionando salida estándar y errores
					pacman -S --needed nvme-cli --noconfirm >/dev/null 2>&1
					
					# Limpiamos pantalla para que la info de salud sea lo único que se vea
					menu_header
					print_title "SALUD NVME: $DISCO"
					nvme smart-log "$DISCO" 2>/dev/null || printf "${orange}[!] Nota: Log de salud NVMe no disponible.${end}\n"
				else
					pacman -S --needed smartmontools --noconfirm >/dev/null 2>&1
					
					menu_header
					print_title "SALUD SMART: $DISCO"
					
					# Redirigimos stderr (2) al limbo (/dev/null) para que no ensucie la pantalla
					if ! smartctl -a "$DISCO" 2>/dev/null; then
						printf "${orange}[!] Nota: SMART no disponible o no soportado en este disco.${end}\n"
					fi
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
