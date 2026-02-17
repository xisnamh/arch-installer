#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS Y LLAVES MAESTRAS
menu_header
print_title "CONFIGURACION DE LLAVEROS"

printf "${yellow}[*] Iniciando el llavero local...${end}\n"
pacman-key --init
printf "${green}[+] Llavero local iniciado correctamente.${end}\n"
continuar

printf "${yellow}[*] Cargando llaves maestras de Arch Linux...${end}\n"
pacman-key --populate archlinux
printf "${green}[+] Llaves maestras de Arch Linux cargadas correctamente.${end}\n"
continuar

printf "${yellow}[*] Actualizando el llavero de Arch Linux...${end}\n"
pacman -Sy archlinux-keyring --noconfirm
printf "${green}[+] Llavero actualizado a la ultima version.${end}\n"
continuar

printf "${yellow}[*] Sincronizando bases de datos...${end}\n"
pacman -Syy
printf "${green}[+] Bases de datos sincronizadas.${end}\n"
continuar

printf "\n${green}[+] Configuracion de Llaveros finalizada con exito.${end}\n"
continuar
