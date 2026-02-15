#!/bin/bash

# 6. OPTIMIZACION DE ESPEJOS
while true; do
	clear
	menu_header
	print_title "OPTIMIZACION DE ESPEJOS"
	printf "${yellow}[*] Iniciando Reflector en modo detallado...${end}\n"

	if reflector --verbose --country France --latest 10 --protocol https --age 12 --sort rate --save /etc/pacman.d/mirrorlist; then
		printf "\n${green}[+] Proceso completado. Mirrorlist guardado con exito.${end}\n"
		pausa
		break
	else
		printf "\n${red}[!] Proceso fallido. Mirrorlist no pudo guardarse.${end}\n"
		
		if confirmar "Deseas reintentar la optimizacion?"; then
			continue
		else
			printf "\n${blue}[!] Continuando con el script a pesar del fallo...${end}\n"
			pausa
			break
		fi
	fi
done
