#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS Y LLAVES MAESTRAS
menu_header
printf "${cyan}           CONFIGURACION DE LLAVEROS          ${end}\n"
printf "${cyan}==========================================${end}\n"

printf "${yellow}[*] Iniciando el llavero local...${end}\n"
sudo pacman-key --init

printf "${yellow}[*] Cargando llaves maestras oficiales...${end}\n"
sudo pacman-key --populate archlinux

printf "${yellow}[*] Actualizando el llavero de Arch Linux...${end}\n"
sudo pacman -Sy archlinux-keyring --noconfirm

printf "${yellow}[*] Sincronizando bases de datos...${end}\n"
sudo pacman -Syy

printf "\n${green}[+] Llaveros configurados con exito.${end}\n"
printf "${green}[+] Bases de datos actualizadas y listas para pacstrap.${end}\n"

pausa
