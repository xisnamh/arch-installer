#!/bin/bash

# 7. PARTICIONAR DISCOS
while true; do
	# SELECCION DE DISCO
	while true; do
		menu_header
		print_title "PRE-INSTALACION: DISCOS"

		printf "${gray}Discos detectados en el sistema:${end}\n"
		lsblk -p -n -l -o NAME,SIZE,TYPE | grep "disk"
		printf "\n"

		printf "${ico_input} Escribe la ruta del disco: ${end}"
		read -r DISCO

		if [ -z "$DISCO" ]; then
			printf "${ico_error}${redl} Ruta del disco seleccionada no valida.${end}\n"
			sleep $T_ERR
		elif [ -b "$DISCO" ]; then
			printf "${ico_ok}${greenl} Ruta del disco seleccionada correctamente.${end}\n"
			sleep $T_INFO
			break
		else
			printf "${ico_error}${redl} Ruta del disco seleccionada no valida.${end}\n"
			sleep $T_ERR
		fi
	done

	# MENU DE ACCIONES
	VOLVER_AL_PASO_1=false

	# DETECCION DE SSD/HDD
	ROTA_VAL=$(cat "/sys/block/$(basename "$DISCO")/queue/rotational" 2>/dev/null)
	if [ "$ROTA_VAL" == "0" ]; then
		TIPO_DISCO="SSD"
	else
		TIPO_DISCO="HDD"
	fi

	while true; do
		menu_header
		print_title "PRE-INSTALACION: DISCOS"

		printf "${gray}Detalles del dispositivo seleccionado:${end}\n"
		if [ "$IS_VM" = true ]; then
			lsblk -p -o NAME,SIZE,TYPE,TRAN,VENDOR,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
		else
			lsblk -p -o NAME,SIZE,TYPE,TRAN,ROTA,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
		fi
		printf "\n"
		
		printf "Selecciona la operacion:\n"
		printf " 1) Ver salud/informacion\n"
		printf " 2) Borrado de fabrica\n"
		printf " 3) Eliminar firmas y tablas\n"
		printf " 4) Particionar con cfdisk\n"
		printf " 5) Modo Manual\n"
		printf " 6) Volver a seleccionar disco\n"
		printf " 7) Finalizar y continuar\n"

		print_ask
		read -r disco_opt

		case $disco_opt in
			1)
				menu_header
				print_title "PRE-INSTALACION: DISCOS"
				if [[ "$DISCO" == *"nvme"* ]]; then
					pacman -S --needed nvme-cli --noconfirm >/dev/null 2>&1
					menu_header
					print_title "PRE-INSTALACION: DISCOS"
					if ! nvme smart-log "$DISCO" >/dev/null 2>&1; then
						printf "${ico_info}${redd} Nota: Log de salud NVMe no disponible.${end}\n"
					else
						nvme smart-log "$DISCO"
					fi
				else
					pacman -S --needed smartmontools --noconfirm >/dev/null 2>&1
					menu_header
					print_title "PRE-INSTALACION: DISCOS"
					
					# Comprobacion estandar
					if smartctl -H "$DISCO" >/dev/null 2>&1; then
						smartctl -H "$DISCO" | grep -E "result|status" || smartctl -H "$DISCO"
					
					# Comprobacion adaptador usb-sata
					elif smartctl -d sat -H "$DISCO" >/dev/null 2>&1; then
						printf "${ico_info}${greenl} Adaptador USB detectado.${end}\n"
						smartctl -d sat -H "$DISCO" | grep -E "result|status" || smartctl -d sat -H "$DISCO"				
					else
						printf "${ico_info}${redd} Nota: SMART no disponible o no soportado.${end}\n"
					fi
				fi
				print_continue
				;;
			2)
				menu_header
				print_title "PRE-INSTALACION: DISCOS"
				if [[ "$DISCO" == *"nvme"* ]]; then
					printf "${gray}Este proceso limpia las celdas de memoria a nivel hardware.${end}\n"

					if print_confirm "¿Deseas realizar un borrado de fabrica?"; then
						pacman -S --needed nvme-cli --noconfirm >/dev/null 2>&1
						
						# Iniciamos el borrado
						if nvme sanitize "$DISCO" --sanact=3 >/dev/null 2>&1; then
							printf "${ico_info} Borrado iniciado. Mostrando progreso...\n"
						
							# Bucle de progreso
							while true; do
								# Extraemos el porcentaje del log de sanitize
								progreso=$(nvme sanitize-log "$DISCO" | grep "Progress" | awk '{print $NF}' | tr -d '()%')
								status=$(nvme sanitize-log "$DISCO" | grep "Status" | awk '{print $NF}')
						
								# Si el status es 0x0 es que finalizo correctamente
								if [[ "$status" == "0x0" || "$status" == "0" ]]; then
									printf "\r${ico_ok}${greenl} Borrado fisico completado al 100%%.          ${end}\n"
									break
								fi
								
								# Validar que $progreso sea un número entero (0-100)
								if [[ "$progreso" =~ ^[0-9]+$ ]]; then
									printf "\r\033[K${ico_info} Progreso: ${redd}${progreso}%%${end} "
								else
									# Si el firmware aun no devuelve un numero, evitamos que el script de un error visual
									printf "\r\033[K${ico_info} Progreso: ${gray}Esperando respuesta del disco...${end} "
								fi
								sleep 2
							done
                    				else
							printf "${ico_error}${redd} El disco no soporta Sanitize Overwrite.${end}\n"
						fi
					fi
				else
					printf "${gray}Se borraran todos los datos de forma irreversible.${end}\n"
					printf "\n"

					if print_confirm "¿Estas seguro?"; then
						# Detectar si es SSD (0) o HDD (1)
						ROTA=$(cat "/sys/block/$(basename $DISCO)/queue/rotational" 2>/dev/null)

						if [ "$ROTA" == "0" ]; then
							printf "${ico_info} Ejecutando blkdiscard (SSD/Trim)... "
							if blkdiscard -f "$DISCO"; then
								printf "${greenl}Hecho.${end}\n"
							else
								printf "${redl}Fallo.${end} Intentando borrado con ceros...\n"
								dd if=/dev/zero of="$DISCO" bs=1M status=progress conv=fdatasync
							fi
						else
							printf "\n"
							printf "${ico_warn}${redd} Detectado HDD.${end}\n"
							printf "${ico_info}${redd} Iniciando borrado con ceros...${end}\n"
							dd if=/dev/zero of="$DISCO" bs=1M status=progress conv=fdatasync
							printf "${ico_ok}${greenl} Borrado con ceros finalizado correctamente.${end}\n"
						fi
					fi
				fi
				print_continue
				;;
			3)
				menu_header
				print_title "PRE-INSTALACION: DISCOS"
				printf "${ico_warn}${redd} Se eliminaran las firmas y las tablas de particiones.${end}\n"
				printf "\n"

				if print_confirm "¿Estas seguro?"; then
					pacman -S --needed gptfdisk --noconfirm >/dev/null 2>&1
					
					printf "${ico_star} Eliminando firmas... "
					wipefs -a "$DISCO"
					
					printf "\n${ico_star} Eliminando tablas de particiones... "
					sgdisk --zap-all "$DISCO"
					
					printf "${ico_ok}${greenl} Firmas y tablas de particiones eliminadas correctamente.${end}\n"
				fi
				print_continue
				;;
			4)
				cfdisk "$DISCO"
				;;
			5)
				menu_header
				print_title "PRE-INSTALACION: DISCOS"
				printf "${ico_warn}${redd} Entrando a la shell.${end}\n"
				printf "${ico_info}${redd} Escribe 'exit' o pulsa Ctrl+D para volver.${end}\n"
				
				# Abrimos shell.
				/bin/bash --norc
				clear
				;;
			6)
				VOLVER_AL_PASO_1=true
				break
				;;
			7)
				menu_header
				print_title "PRE-INSTALACION: DISCOS"
				
				printf "${gray}Detalles del dispositivo seleccionado:${end}\n"
				if [ "$IS_VM" = true ]; then
					lsblk -p -o NAME,SIZE,TYPE,TRAN,VENDOR,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
				else
					lsblk -p -o NAME,SIZE,TYPE,TRAN,ROTA,FSTYPE,MOUNTPOINTS | grep -E "NAME|$DISCO" | column -t -o '    '
				fi
				printf "\n"
				
				if print_confirm "¿Finalizar la configuracion de discos?"; then
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
