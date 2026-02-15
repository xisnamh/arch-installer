#!/bin/bash

# 7. INSTALACION DE REPOSITORIOS CACHYOS
menu_header
print_title "CONFIGURACION DE CACHYOS"

# Bucle estricto para la pregunta inicial
SKIP_CACHY=false
while true; do
	printf "${yellow}¿Deseas descargar e instalar los repositorios de CachyOS? (s/n): ${end}"
	read respuesta_cachy
	case $respuesta_cachy in
		[Ss]) break ;;
		[Nn]) SKIP_CACHY=true; break ;;
		*)
			printf "\e[1A\e[K${red}[!] Opcion no valida.${end}"; sleep 1; printf "\r\e[K"
			;;
	esac
done

if [ "$SKIP_CACHY" = false ]; then
	printf "${yellow}[*] Descargando instalador de CachyOS...${end}\n"
	curl -L https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
	tar xvf cachyos-repo.tar.xz
	cd cachyos-repo

	# Dos saltos de linea antes de la advertencia
	printf "\n\n"

	# Mensaje de Advertencia
	printf "${red}!!!!!!!!!!!!!!!!!! ADVERTENCIA !!!!!!!!!!!!!!!!!!${end}\n"
	printf "${cyan}- Solo anadir los repos cachyos para instalar, en pacstrap, los kernels y las librerias de cachyos.${end}\n"
	printf "${cyan}- No instalar la libreria zlib-ng-compat, todavia estamos fuera del entorno chroot.${end}\n"
	printf "${cyan}- No instalar los paquetes, todavia estamos fuera del entorno chroot.${end}\n"
	printf "\n"

	printf "${yellow}[!] A continuacion se ejecutara el script oficial de CachyOS.${end}\n"
	pausa

	./cachyos-repo.sh

	printf "\n${green}[+] El script oficial de CachyOS ha finalizado correctamente.${end}\n"
	pausa

	menu_header
	print_title "CONFIGURACION DE CACHYOS"

	printf "${yellow}[*] Preparando edicion de /etc/pacman.conf...${end}\n"
	printf "\n"
	printf "${cyan}INSTRUCCIONES DE CONFIGURACION:${end}\n"
	printf "${white}- Descomenta #color, #prettyprogressbar y #ilovecandy.${end}\n"
	printf "${white}- Mueve los repos [cachyos-v3] y [cachyos-core-v3] al principio de la lista.${end}\n"
	printf "${white}- Deshabilita los repos [cachyos-extra-v3] y [cachyos] (comenta con #).${end}\n"
	pausa

	# Bucle de edicion manual con validacion estricta
	while true; do
		nano /etc/pacman.conf

		printf "${yellow}¿Has terminado de modificar el archivo correctamente? (s/n): ${end}"
		read confirmacion
		case $confirmacion in
			[Ss]) break ;;
			[Nn])
				printf "${blue}[!] Reabriendo el archivo para correcciones...${end}\n"
				sleep 1
				;;
			*)
				printf "\e[1A\e[K${red}[!] Opcion no valida.${end}"; sleep 1; printf "\r\e[K"
				;;
		esac
	done

	printf "\n${green}[+] Configuracion de CachyOS finalizada con exito.${end}\n"
	cd ..
	pausa
else
	# Opcion si se responde que NO
	printf "\n${green}[+] Configuracion de CachyOS omitida por el usuario.${end}\n"
	pausa
fi
