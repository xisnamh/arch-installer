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
		
		# Modelo inteligente (con detección de VM)
		MODELO_DISCO=$(lsblk -d -n -o MODEL "$DISCO" | xargs)
		if [ -z "$MODELO_DISCO" ] && [ "$IS_VM" = true ]; then
			MODELO_DISCO="Maquina Virtual ($(systemd-detect-virt | tr '[:lower:]' '[:upper:]'))"
		fi
		[ -n "$MODELO_DISCO" ] && printf "${blue}Modelo:${end} $MODELO_DISCO\n"

		printf "${blue}Detalles del dispositivo:${end}\n"
		if [ "$IS_VM" = true ]; then
			lsblk -p -o NAME,SIZE,TYPE,TRAN,VENDOR,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
		else
			lsblk -p -o NAME,SIZE,TYPE,TRAN,ROTA,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
		fi
		printf "\n"
		
		printf "Selecciona la operacion:\n"
		printf " 1) Ver salud/info (SMART/NVMe)\n"
		printf " 2) Borrado de fabrica (NVMe Sanitize)\n"
		printf " 3) Limpiar firmas y tablas (wipefs/zap-all)\n"
		printf " 4) Particionar con cfdisk\n"
		printf " 5) Abrir Terminal (Modo Manual)\n"
		printf " 6) Volver atras (Cambiar disco)\n"
		printf " 7) Finalizar y continuar\n"

		pregunta
		read disco_opt

		case $disco_opt in
			1)
				if [[ "$DISCO" == *"nvme"* ]]; then
					pacman -S --needed nvme-cli --noconfirm >/dev/null 2>&1
					menu_header
					print_title "SALUD NVME: $DISCO"
					if ! nvme smart-log "$DISCO" >/dev/null 2>&1; then
						printf "${orange}[!] Nota: Log de salud NVMe no disponible.${end}\n"
					else
						nvme smart-log "$DISCO"
					fi
				else
					pacman -S --needed smartmontools --noconfirm >/dev/null 2>&1
					menu_header
					print_title "SALUD SMART: $DISCO"
					if ! smartctl -H "$DISCO" >/dev/null 2>&1; then
						printf "${orange}[!] Nota: SMART no disponible o no soportado.${end}\n"
					else
						smartctl -H "$DISCO" | grep -E "result|status" || smartctl -H "$DISCO"
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
				menu_header
				print_title "MODO MANUAL: TERMINAL"
				printf "${yellow}[!] Entrando en shell interactiva sobre: $DISCO${end}\n"
				printf "${cyan}[i] Escribe 'exit' o pulsa Ctrl+D para volver al instalador.${end}\n\n"
				
				# Abrimos bash. El prompt personalizado ayuda a saber que estamos en modo manual.
				PS1="(MODO-MANUAL) \u@archiso \w \$ " /bin/bash --norc
				
				printf "\n${green}[+] Has salido de la terminal.${end}\n"
				pausa  # Aquí te pregunta si has acabado para volver al menú
				;;
			6)
				VOLVER_AL_PASO_1=true
				break
				;;
			7)
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
