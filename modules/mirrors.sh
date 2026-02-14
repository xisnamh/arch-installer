#!/bin/bash

# 6. OPTIMIZACION DE ESPEJOS (REFLECTOR)
menu_header
printf "${cyan}          OPTIMIZACION DE ESPEJOS         ${end}\n"
printf "${cyan}==========================================${end}\n"
printf "${yellow}[*] Iniciando Reflector en modo detallado (Francia)...${end}\n"

if reflector --verbose --country France --latest 10 --protocol https --age 12 --sort rate --save /etc/pacman.d/mirrorlist; then
	printf "\n${green}[+] Proceso finalizado. Mirrorlist guardado con exito.${end}\n"
else
	printf "\n${red}[!] Reflector termino con algunas advertencias o errores.${end}\n"
fi

pausa
