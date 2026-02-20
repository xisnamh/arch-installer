#!/bin/bash

# 8. CONFIGURACION DE LLAVEROS
menu_header
print_title "LLAVES"

printf "${ico_star} ${greend}Iniciando el llavero local...${end}\n"
pacman-key --init
printf "${ico_ok} ${greenl}Llavero local iniciado correctamente.${end}\n"
print_continue

printf "${ico_star} ${greend}Cargando las llaves maestras...${end}\n"
pacman-key --populate archlinux
printf "${ico_ok} ${greenl}Llaves maestras cargadas correctamente.${end}\n"
print_continue

printf "${ico_star} ${greend}Actualizando el llavero...${end}\n"
pacman -Sy archlinux-keyring --noconfirm
printf "${ico_ok} ${greenl}Llavero actualizado correctamente.${end}\n"
print_continue

printf "${ico_star} ${greend}Sincronizando las bases de datos...${end}\n"
pacman -Syy
printf "${ico_ok} ${greenl}Bases de datos sincronizadas correctamente.${end}\n"
print_continue

printf "\n${ico_ok} ${greenl}Configuracion de llaves finalizada correctamente.${end}\n"
print_continue
