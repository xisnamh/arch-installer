#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS Y LLAVES MAESTRAS
menu_header
printf "${cyan}          CONFIGURACION DE LLAVEROS          ${end}\n"
printf "${cyan}==========================================${end}\n"

printf "${yellow}[*] Iniciando el llavero local...${end}\n"
sudo pacman-key --init
pausa

printf "${yellow}[*] Cargando llaves maestras oficiales...${end}\n"
sudo pacman-key --populate archlinux
pausa

printf "${yellow}[*] Actualizando el llavero de Arch Linux...${end}\n"
sudo pacman -Sy archlinux-keyring --noconfirm
pausa

printf "${yellow}[*] Sincronizando bases de datos...${end}\n"
sudo pacman -Syy
pausa

printf "\n${green}[+] Llaveros configurados con exito.${end}\n"
printf "${green}[+] Bases de datos actualizadas y listas para pacstrap.${end}\n"

pausa
