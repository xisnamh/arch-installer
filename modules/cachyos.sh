#!/bin/bash

# 7. INSTALACION DE REPOSITORIOS CACHYOS
menu_header
print_title "CACHYOS REPOSITORIOS"

if print_confirm "Deseas descargar e instalar los repositorios de CachyOS?"; then
	
	# BUCLE DE DESCARGA CON REINTENTO
	while true; do
		printf "${ico_star} ${greend}Descargando instalador...${end}\n"
		
		# Intentamos la descarga
		if curl -L https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz; then
			printf "${ico_ok} ${greenl}Descarga completada correctamente.${end}\n"
			break # Sale del bucle si funciona
		else
			print_error_box "Error al descargar el repositorio de CachyOS."
			
			# Pregunta si quiere reintentar
			if print_confirm "La descarga fallo. ¿Quieres volver a intentarlo?"; then
				continue # Vuelve al principio del while para reintentar
			else
				printf "\n${ico_error} ${red}Instalacion de CachyOS cancelada por el usuario.${end}\n"
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
	print_info_box "AVISO IMPORTANTE"
	printf "  ${ico_item} Repositorios CachyOS: Añadir para instalar kernels y librerias.\n"
	printf "  ${ico_item} Libreria zlib-ng-compat: No instalar, estamos fuera de chroot.\n"
	printf "  ${ico_item} Paquetes restantes: No instalar, estamos fuera de chroot.\n"
	print_info_end
	printf "\n"

	printf "${ico_warn} ${white}A continuacion se ejecutara el script oficial de CachyOS.${end}\n"
	print_continue

	./cachyos-repo.sh

	printf "\n${ico_ok} ${greenl}El script oficial de CachyOS ha finalizado correctamente.${end}\n"
	
	# Volver atras para que el instalador encuentre los siguientes modulos
	cd ..

	menu_header
	print_title "CONFIGURACION DE CACHYOS"

	printf "${ico_star} ${greend}Preparando edicion de /etc/pacman.conf...${end}\n"
	printf "\n\n"
	
	print_info_box "INSTRUCCIONES DE CONFIGURACION"
	printf "  ${ico_item} Descomenta #color, #prettyprogressbar y #ilovecandy.\n"
	printf "  ${ico_item} Mueve los repositorios [cachyos-v3] y [cachyos-core-v3] al principio de la lista.\n"
	printf "  ${ico_item} Deshabilita los repositorios [cachyos-extra-v3] y [cachyos] (comenta con #).\n"
	print_info_end
	
	print_continue

	# Bucle de edicion manual
	while true; do
		nano /etc/pacman.conf

		if print_confirm "Has terminado de modificar el archivo correctamente?"; then
			break
		else
			printf "${ico_warn} ${orange}Reabriendo el archivo para correcciones...${end}\n"
			sleep $T_INFO
		fi
	done

	printf "\n${ico_ok} ${green}Configuracion de CachyOS finalizada con exito.${end}\n"
	print_continue

else
	# Opcion si se responde NO al principio
	printf "\n${ico_warn} ${orange}Configuracion de CachyOS omitida por el usuario.${end}\n"
	print_continue
fi
