#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS Y LLAVES MAESTRAS
menu_header
print_title "CONFIGURACION DE LLAVEROS"

printf "${yellow}[*] Iniciando el llavero local...${end}\n"
sudo pacman-key --init
printf "${green}[+] Llavero local iniciado correctamente.${end}\n"
pausa

printf "${yellow}[*] Cargando llaves maestras de Arch Linux...${end}\n"
sudo pacman-key --populate archlinux
printf "${green}[+] Llaves maestras de Arch Linux cargadas correctamente.${end}\n"
pausa

printf "${yellow}[*] Actualizando el llavero de Arch Linux...${end}\n"
sudo pacman -Sy archlinux-keyring --noconfirm
printf "${green}[+] Llavero actualizado a la ultima version.${end}\n"
pausa

printf "${yellow}[*] Sincronizando bases de datos...${end}\n"
sudo pacman -Syy
printf "${green}[+] Bases de datos sincronizadas.${end}\n"
pausa

printf "\n${green}[+] PROCESO COMPLETO: Llaveros y repositorios listos.${end}\n"
pausa
