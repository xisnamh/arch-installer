#!/bin/bash

# 6. OPTIMIZACION DE ESPEJOS
while true; do
	clear
	menu_header
	print_title "OPTIMIZACION DE ESPEJOS"
	printf "${yellow}[${ico_star}] Iniciando Reflector en modo detallado...${end}\n"

	if reflector --verbose --country France --latest 10 --protocol https --age 12 --sort rate --save /etc/pacman.d/mirrorlist; then
		printf "\n${green}[${ico_ok}] Optimizacion de espejos finalizada con exito.${end}\n"
		print_continue
		break
	else
		printf "\n${red}[${ico_error}] Optimizacion de espejos finalizada con error.${end}\n"
		
		if print_confirm "Deseas reintentar la optimizacion de espejos?"; then
			continue
		else
			printf "\n${blue}[${ico_info}] Optimizacion de espejos omitida por el usuario.${end}\n"
			print_continue
			break
		fi
	fi
done
