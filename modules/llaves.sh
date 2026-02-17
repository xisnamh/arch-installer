#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS Y LLAVES MAESTRAS
menu_header
print_title "CONFIGURACION DE LLAVEROS"

printf "${yellow}[${ico_star}] Iniciando el llavero local...${end}\n"
pacman-key --init
printf "${green}[${ico_ok}] Llavero local iniciado correctamente.${end}\n"
print_continue

printf "${yellow}[${ico_star}] Cargando llaves maestras de Arch Linux...${end}\n"
pacman-key --populate archlinux
printf "${green}[${ico_ok}] Llaves maestras de Arch Linux cargadas correctamente.${end}\n"
print_continue

printf "${yellow}[${ico_star}] Actualizando el llavero de Arch Linux...${end}\n"
pacman -Sy archlinux-keyring --noconfirm
printf "${green}[${ico_ok}] Llavero actualizado a la ultima version.${end}\n"
print_continue

printf "${yellow}[${ico_star}] Sincronizando bases de datos...${end}\n"
pacman -Syy
printf "${green}[${ico_ok}] Bases de datos sincronizadas.${end}\n"
print_continue

printf "\n${green}[${ico_ok}] Configuracion de Llaveros finalizada con exito.${end}\n"
print_continue
