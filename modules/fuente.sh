#!/bin/bash

# 0. LOCALES PARA LA SESION ACTUAL
# Soporte para caracteres utf-8
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
locale-gen > /dev/null 2>&1

# Establecer idioma español a la terminal
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# Funcion interna para no repetir ccdigo del menu
font_menu() {
	clear
	menu_header
	print_title "PRE-INSTALACION: FUENTE (TTY)"
	printf "${gray}Selecciona un tamaño de fuente para la consola:${end}\n"
	printf " 1) Normal   (Tamaño estandar)\n"
	printf " 2) Mediana  (Recomendado 1080p)\n"
	printf " 3) Grande   (Recomendado 2K/4K)\n"
	printf " 4) Saltar / No cambiar\n"
}

# 1. CONFIGURACION DE FUENTE (TTY)
while true; do
	font_menu
	print_ask
	read -r font_opt || { printf "\n"; print_novalid; continue; }

	case $font_opt in
		1) FONT="ter-918b" ;;
		2) FONT="ter-924b" ;;
		3) FONT="ter-932b" ;;
		4) break ;;
		*)
			print_novalid
			continue
			;;
	esac

	# Aplicamos la fuente para que el usuario vea el cambio
	setfont "$FONT" 2>/dev/null

	# Volvemos a pintar todo el menu con la fuente nueva antes de lanzar el print_confirm
	font_menu
	printf "\n"

	if print_confirm "¿Te gusta este tamaño de fuente?"; then
		printf "${ico_ok} ${greenl}Tamaño de fuente configurado correctamente.${end}\n"
		print_continue
		break
	else
		# Si no le gusta, restauramos la fuente por defecto y vuelve al inicio del bucle
		setfont lat9w-16 2>/dev/null
	fi
done
