#!/bin/bash

# 0. LOCALES PARA LA SESION ACTUAL
# Soporte para caracteres utf-8
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
locale-gen > /dev/null 2>&1

# Establecer idioma español a la terminal
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# 1. CONFIGURACION DE FUENTE (TTY)
while true; do
	clear
	menu_header
	print_title "CONFIGURACION DE FUENTE (TTY)"
	printf "${blue}Selecciona un tamaño de letra para la consola:${end}\n"
	printf " 1) Normal   (Tamaño estandar)\n"
	printf " 2) Mediana  (Recomendado 1080p)\n"
	printf " 3) Grande   (Recomendado 2K/4K)\n"
	printf " 4) Saltar / No cambiar\n"

	print_ask
	read -r font_opt

	case $font_opt in
		1) FONT="ter-v18b" ;;
		2) FONT="ter-v24b" ;;
		3) FONT="ter-v32b" ;;
		4) break ;;
		*)
			printf "${ico_error} ${red}Opcion no valida${end}\n"
			sleep $T_ERR
			continue
			;;
	esac

	# Aplicamos la fuente para que el usuario vea el cambio
	setfont "$FONT" 2>/dev/null

	if print_confirm "Te gusta este tamaño?"; then
		printf "${ico_ok} ${green}Fuente configurada correctamente.${end}\n"
		sleep $T_INFO
		break
	else
		# Si no le gusta, restauramos la fuente por defecto y vuelve al inicio del bucle
		setfont lat9w-16 2>/dev/null
	fi
done
