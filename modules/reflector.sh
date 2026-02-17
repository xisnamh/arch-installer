#!/bin/bash

# 6. OPTIMIZACION DE ESPEJOS
while true; do
	clear
	menu_header
	print_title "OPTIMIZACION DE ESPEJOS"
	printf "${yellow}[*] Iniciando Reflector en modo detallado...${end}\n"

	if reflector --verbose --country France --latest 10 --protocol https --age 12 --sort rate --save /etc/pacman.d/mirrorlist; then
		printf "\n${green}[+] Optimizacion de espejos finalizada con exito.${end}\n"
		continuar
		break
	else
		printf "\n${red}[!] Optimizacion de espejos finalizada con error.${end}\n"
		
		if confirmar "Deseas reintentar la optimizacion de espejos?"; then
			continue
		else
			printf "\n${blue}[!] Optimizacion de espejos omitida por el usuario.${end}\n"
			continuar
			break
		fi
	fi
done
