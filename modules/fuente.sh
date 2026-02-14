#!/bin/bash

# 1. CONFIGURACION DE FUENTE (TTY)
while true; do
	clear
	menu_header
	print_title "CONFIGURACION DE FUENTE (TTY)"
	printf "Selecciona un tamano de letra para la consola:\n"
	printf " 1) Normal   (Tamano estandar)\n"
	printf " 2) Mediana  (Recomendado 1080p)\n"
	printf " 3) Grande   (Recomendado 2K/4K)\n"
	printf " 4) Saltar / No cambiar\n"
	printf "Elige una opcion [1-4]: "
	read font_opt

	case $font_opt in
		1) FONT="ter-v18b" ;;
		2) FONT="ter-v24b" ;;
		3) FONT="ter-v32b" ;;
		4) break ;;
		*)
			printf "${red}[!] Opcion no valida.${end}\n"
			sleep 1
			continue
			;;
	esac

	# Aplicamos la fuente para que el usuario vea el cambio
	setfont $FONT 2>/dev/null

	while true; do
		printf "${yellow}¿Te gusta este tamano? (s/n):${end} "
		read confirm_font

		case $confirm_font in
			[Ss]) printf "${green}[+] Fuente configurada.${end}\n"; sleep 1; break 2 ;;
			[Nn]) setfont lat9w-16 2>/dev/null; break ;;
			*)
				# Sube, borra la linea escrita, muestra error, espera y borra el error
				printf "\e[1A\e[K${red}[!] Opcion no valida.${end}"; sleep 1; printf "\r\e[K"
				;;
		esac
	done
done
