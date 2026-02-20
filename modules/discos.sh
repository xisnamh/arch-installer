while true; do
	# --- PASO 1 Y 2: SELECCION DE DISCO ---
	while true; do
		menu_header
		print_title "DISCOS"

		printf "${gray}Discos detectados en el sistema:${end}\n"
		lsblk -p -n -l -o NAME,SIZE,TYPE | grep "disk"
		printf "\n"

		printf "${yellow}Escribe la ruta del disco (ej: /dev/nvme0n1): ${end}"
		read -r DISCO

		if [ -z "$DISCO" ]; then
			printf "${ico_error}${redd} No has escrito nada.${end}\n"
			sleep $T_ERR
		elif [ -b "$DISCO" ]; then
			printf "${ico_ok}${greenl} Disco seleccionado correctamente: $DISCO${end}\n"
			sleep $T_INFO
			break
		else
			printf "${ico_error}${redd} El dispositivo '$DISCO' no existe o no es valido.${end}\n"
			sleep $T_ERR
		fi
	done

	# --- PASO 3: MENU DE ACCIONES ---
	VOLVER_AL_PASO_1=false

	while true; do
		menu_header
		print_title "DISCO SELECCIONADO: $DISCO"

		printf "${gray}Detalles del dispositivo:${end}\n"
		if [ "$IS_VM" = true ]; then
			lsblk -p -o NAME,SIZE,TYPE,TRAN,VENDOR,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
		else
			lsblk -p -o NAME,SIZE,TYPE,TRAN,ROTA,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
		fi
		printf "\n"
		
		printf "Selecciona la operacion:\n"
		printf " 1) Ver salud/info\n"
		printf " 2) Borrado de fabrica\n"
		printf " 3) Limpiar firmas y tablas\n"
		printf " 4) Particionar con cfdisk\n"
		printf " 5) Modo Manual\n"
		printf " 6) Volver atras\n"
		printf " 7) Finalizar y continuar\n"

		print_ask
		read -r disco_opt

		case $disco_opt in
			1)
				if [[ "$DISCO" == *"nvme"* ]]; then
					pacman -S --needed nvme-cli --noconfirm >/dev/null 2>&1
					menu_header
					print_title "SALUD NVME: $DISCO"
					if ! nvme smart-log "$DISCO" >/dev/null 2>&1; then
						printf "${ico_info}${redd} Nota: Log de salud NVMe no disponible.${end}\n"
					else
						nvme smart-log "$DISCO"
					fi
				else
					pacman -S --needed smartmontools --noconfirm >/dev/null 2>&1
					menu_header
					print_title "SALUD SMART: $DISCO"
					if ! smartctl -H "$DISCO" >/dev/null 2>&1; then
						printf "${ico_info}${redd} Nota: SMART no disponible o no soportado.${end}\n"
					else
						smartctl -H "$DISCO" | grep -E "result|status" || smartctl -H "$DISCO"
					fi
				fi
				print_continue
				;;
			2)
				if [[ "$DISCO" == *"nvme"* ]]; then
					print_error "BORRADO FISICO: $DISCO"
					printf "${white}Escribe ${redd}BORRAR${white} para confirmar:${end} "
					read -r confirm
					if [ "$confirm" == "BORRAR" ]; then
						pacman -S --needed nvme-cli --noconfirm >/dev/null 2>&1
						nvme sanitize "$DISCO" --sanact=3
					fi
				fi
				print_continue
				;;
			3)
				printf "${ico_warn}${redd} Eliminando firmas y tablas de particiones en $DISCO...${end}\n"
				pacman -S --needed gptfdisk --noconfirm >/dev/null 2>&1
				wipefs -a "$DISCO"
				sgdisk --zap-all "$DISCO"
				printf "${ico_ok}${greenl} Firmas y tablas de particiones eliminadas correctamente.${end}\n"
				print_continue
				;;
			4)
				cfdisk "$DISCO"
				;;
			5)
				menu_header
				print_title "MODO MANUAL: TERMINAL"
				printf "${ico_warn}${redd} Entrando en shell interactiva.${end}\n"
				printf "${ico_info}${redd} Escribe 'exit' o pulsa Ctrl+D para volver al instalador.${end}\n\n"
				
				# Abrimos shell.
				/bin/bash --norc
				;;
			6)
				VOLVER_AL_PASO_1=true
				break
				;;
			7)
				menu_header
				print_title "RESUMEN FINAL"
				lsblk "$DISCO"
				printf "\n"
				if print_confirm "¿Todo listo para continuar con el particionado actual?"; then
					break 2
				fi
				;;
			*)
				print_novalid
				;;
		esac
	done

	if [ "$VOLVER_AL_PASO_1" = false ]; then
		break
	fi
done
