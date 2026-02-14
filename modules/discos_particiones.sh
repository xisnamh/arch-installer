#!/bin/bash

# --- PASO 1 Y 2: SELECCION DE DISCO CON AUTO-REFRESCO ---
while true; do
	menu_header
	print_title "GESTION DE DISCOS"

	# Listado de discos
	printf "${blue}Discos detectados en el sistema:${end}\n"
	lsblk -p -n -l -o NAME,SIZE,MODEL,TYPE | grep -E "disk"
	printf "\n"

	printf "${yellow}Escribe la ruta del disco (ej: /dev/nvme0n1): ${end}"
	read DISCO

	if [ -z "$DISCO" ]; then
		printf "${red}[!] No has escrito nada.${end}"
		sleep 1.5
	elif [ -b "$DISCO" ]; then
		printf "${green}[+] Disco seleccionado: $(lsblk -dn -o MODEL $DISCO)${end}\n"
		sleep 1
		break
	else
		printf "${red}[!] El dispositivo '$DISCO' no existe o no es valido.${end}"
		sleep 1.5
	fi
done

# --- PASO 3: MENU DE ACCIONES ---
while true; do
	menu_header
	print_title "DISCO SELECCIONADO: $DISCO"
	printf "Selecciona la operacion:\n"
	printf " 1) Ver salud/info (SMART/NVMe)\n"
	printf " 2) Borrado de fabrica (NVMe Sanitize - ¡PELIGRO!)\n"
	printf " 3) Limpiar firmas y tablas (wipefs/zap-all)\n"
	printf " 4) Particionar con cfdisk (Recomendado)\n"
	printf " 5) Finalizar y continuar con la instalacion\n"
	printf "Elige una opcion [1-5]: "
	read disco_opt

	case $disco_opt in
		1)
			if [[ "$DISCO" == *"nvme"* ]]; then
				sudo pacman -S --needed nvme-cli --noconfirm
				sudo nvme smart-log "$DISCO"
			else
				sudo pacman -S --needed smartmontools --noconfirm
				sudo smartctl -a "$DISCO"
			fi
			pausa
			;;
		2)
			if [[ "$DISCO" == *"nvme"* ]]; then
				printf "${red}ADVERTENCIA: Esto borrara el disco a nivel fisico.${end}\n"
				printf "¿Estas ABSOLUTAMENTE seguro? (escribe 'BORRAR'): "
				read confirm
				if [ "$confirm" == "BORRAR" ]; then
					sudo pacman -S --needed nvme-cli --noconfirm
					sudo nvme sanitize "$DISCO" --sanact=3
					printf "${yellow}[*] Sanitize iniciado. Revisa progreso con: nvme sanitize-log $DISCO${end}\n"
				fi
			else
				printf "${red}[!] Esta opcion solo es para discos NVMe.${end}\n"
			fi
			pausa
			;;
		3)
			printf "${red}[!] Se borraran las tablas GPT/MBR y firmas de $DISCO.${end}\n"
			printf "¿Continuar? (s/n): "
			read confirm
			if [[ "$confirm" == [Ss] ]]; then
				sudo pacman -S --needed gptfdisk --noconfirm
				sudo wipefs -a "$DISCO"
				sudo sgdisk --zap-all "$DISCO"
				printf "${green}[+] Disco limpio.${end}\n"
			fi
			pausa
			;;
		4)
			sudo cfdisk "$DISCO"
			menu_header
			print_title "NUEVO ESQUEMA DE PARTICIONES"
			lsblk "$DISCO"
			printf "\n"
			pausa
			;;
		5)
			menu_header
			print_title "RESUMEN FINAL"
			lsblk "$DISCO"
			printf "\n${yellow}¿Estan las particiones listas para formatear? (s/n): ${end}"
			read final_conf
			if [[ "$final_conf" == [Ss] ]]; then
				break
			fi
			;;
		*)
			printf "${red}[!] Opcion no valida.${end}\n"
			sleep 1
			;;
	esac
done
