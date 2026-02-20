#!/bin/bash

# 7. INSTALACION DE REPOSITORIOS CACHYOS
menu_header
print_title "REPOSITORIOS CACHYOS"

if print_confirm "¿Deseas descargar e instalar los repositorios de CachyOS?"; then
	
	# BUCLE DE DESCARGA CON REINTENTO
	while true; do
		printf "${ico_star} ${greend}Descargando el instalador de los repositorios de CachyOS...${end}\n"
		
		# Intentamos la descarga
		if curl -L https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz; then
			printf "${ico_ok} ${greenl}Instalador de los repositorios de CachyOS descargado correctamente.${end}\n"
			break # Sale del bucle si funciona
		else
			print_error "Instalador de los repositorios de CachyOS finalizado con error."
			
			# Pregunta si quiere reintentar
			if print_confirm "¿Deseas reintentar el instalador de los repositorios de CachyOS?"; then
				continue # Vuelve al principio del while para reintentar
			else
				printf "\n${ico_error} ${redl}Instalacion de los repositorios de CachyOS omitida por el usuario.${end}\n"
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
	print_info "Aviso Importante"
	printf " ${ico_item} Repositorios CachyOS: Añadir para instalar kernels y librerias.\n"
	printf " ${ico_item} Libreria zlib-ng-compat: No instalar, estamos fuera de chroot.\n"
	printf " ${ico_item} Paquetes restantes: No instalar, estamos fuera de chroot.\n"
	print_info_end
	printf "\n"

	printf "${ico_warn} ${redd}A continuacion se ejecutara el script oficial de CachyOS.${end}\n"
	print_continue

	./cachyos-repo.sh

	printf "\n${ico_ok} ${greenl}El script oficial de CachyOS ha finalizado correctamente.${end}\n"
	
	# Volver atras para que el instalador encuentre los siguientes modulos
	cd ..

	menu_header
	print_title "CONFIGURACION DE CACHYOS"

	printf "${ico_star} ${greend}Preparando edicion de /etc/pacman.conf...${end}\n"
	printf "\n\n"
	
	print_info "Instrucciones"
	printf " ${ico_item} Descomenta #color, #prettyprogressbar y #ilovecandy.\n"
	printf " ${ico_item} Mueve los repositorios [cachyos-v3] y [cachyos-core-v3] al principio de la lista.\n"
	printf " ${ico_item} Deshabilita los repositorios [cachyos-extra-v3] y [cachyos] (comenta con #).\n"
		
	print_continue

	# Bucle de edicion manual
	while true; do
		nano /etc/pacman.conf

		if print_confirm "Has editado el archivo correctamente?"; then
			break
		else
			printf "${ico_warn} ${redd}Reabriendo el archivo para editar...${end}\n"
			sleep $T_INFO
		fi
	done

	printf "\n${ico_ok} ${greenl}Instalacion de los repositorios de CachyOS finalizada correctamente.${end}\n"
	print_continue

else
	# Opcion si se responde NO al principio
	printf "\n${ico_warn} ${redd}Instalacion de los repositorios de CachyOS omitida por el usuario.${end}\n"
	print_continue
fi
