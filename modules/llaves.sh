#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS Y LLAVES MAESTRAS
menu_header
print_title "CONFIGURACION DE LLAVEROS"

printf "${ico_star} ${yellow}Iniciando el llavero local...${end}\n"
pacman-key --init
printf "${ico_ok} ${green}Llavero local iniciado correctamente.${end}\n"
print_continue

printf "${ico_star} ${yellow}Cargando las llaves maestras de Arch Linux...${end}\n"
pacman-key --populate archlinux
printf "${ico_ok} ${green}Llaves maestras de Arch Linux cargadas correctamente.${end}\n"
print_continue

printf "${ico_star} ${yellow}Actualizando el llavero de Arch Linux...${end}\n"
pacman -Sy archlinux-keyring --noconfirm
printf "${ico_ok} ${green}Llavero de Arch Linux actualizado correctamente.${end}\n"
print_continue

printf "${ico_star} ${yellow}Sincronizando las bases de datos...${end}\n"
pacman -Syy
printf "${ico_ok} ${green}Bases de datos sincronizadas correctamente.${end}\n"
print_continue

printf "\n${ico_ok} ${green}Configuracion de Llaveros finalizada con exito.${end}\n"
print_continue
