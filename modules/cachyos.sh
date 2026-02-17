#!/bin/bash

# 7. INSTALACION DE REPOSITORIOS CACHYOS
menu_header
print_title "CONFIGURACION DE CACHYOS"

if print_confirm "Deseas descargar e instalar los repositorios de CachyOS?"; then
	
	# BUCLE DE DESCARGA CON REINTENTO
	while true; do
		printf "${yellow}[*] Descargando instalador de CachyOS...${end}\n"
		
		# Intentamos la descarga
		if curl -L https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz; then
			printf "${green}[+] Descarga completada correctamente.${end}\n"
			break # Sale del bucle si funciona
		else
			print_error_box "Error al descargar el repositorio de CachyOS."
			
			# Pregunta si quiere reintentar
			if print_confirm "La descarga fallo. ¿Quieres volver a intentarlo?"; then
				continue # Vuelve al principio del while para reintentar
			else
				printf "\n${red}[!] Instalacion de CachyOS cancelada por el usuario.${end}\n"
				print_continue
				return 1 # Sale del módulo y vuelve al script principal
			fi
		fi
	done

	# EXTRACCION Y EJECUCION
	tar xvf cachyos-repo.tar.xz
	cd cachyos-repo

	# Mensajes visuales
	printf "\n\n"
	print_warning_box "AVISO IMPORTANTE"
	printf "${red}  󱈸 ${end}${cyan}Repositorios CachyOS:${end} Añadir para instalar kernels y librerias.\n"
	printf "${red}  󱈸 ${end}${cyan}Libreria zlib-ng-compat:${end} No instalar, estamos fuera de chroot.\n"
	printf "${red}  󱈸 ${end}${cyan}Paquetes restantes:${end} No instalar, estamos fuera de chroot.\n"
	print_warning_end
	printf "\n"

	printf "${yellow}[!] A continuacion se ejecutara el script oficial de CachyOS.${end}\n"
	print_continue

	./cachyos-repo.sh

	printf "\n${green}[+] El script oficial de CachyOS ha finalizado correctamente.${end}\n"
	
	# Volver atras para que el instalador encuentre los siguientes modulos
	cd ..

	menu_header
	print_title "CONFIGURACION DE CACHYOS"

	printf "${yellow}[*] Preparando edicion de /etc/pacman.conf...${end}\n"
	printf "\n\n"
	
	print_info_box "INSTRUCCIONES DE CONFIGURACION"
	printf "${gold}  󱈸 ${end}${white}Descomenta #color, #prettyprogressbar y #ilovecandy.${end}\n"
	printf "${gold}  󱈸 ${end}${white}Mueve los repositorios [cachyos-v3] y [cachyos-core-v3] al principio de la lista.${end}\n"
	printf "${gold}  󱈸 ${end}${white}Deshabilita los repositorios [cachyos-extra-v3] y [cachyos] (comenta con #).${end}\n"
	print_info_end
	
	print_continue

	# Bucle de edicion manual
	while true; do
		nano /etc/pacman.conf

		if print_confirm "Has terminado de modificar el archivo correctamente?"; then
			break
		else
			printf "${blue}[!] Reabriendo el archivo para correcciones...${end}\n"
			sleep $T_INFO
		fi
	done

	printf "\n${green}[+] Configuracion de CachyOS finalizada con exito.${end}\n"
	print_continue

else
	# Opcion si se responde NO al principio
	printf "\n${green}[+] Configuracion de CachyOS omitida por el usuario.${end}\n"
	print_continue
fi
