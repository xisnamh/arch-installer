#!/bin/bash

# 8. FORMATEAR PARTICIONES

# Funcion para gestionar la entrada y ejecucion de cada comando de formateo
exec_format() {
	local TAREA="$1"
	local COMANDO_BASE="$2"
	local PARTICION

	while true; do
		menu_header
		print_title "PARTICIONES: FORMATEAR"
		
		printf "${gray}Configurando las particiones:${end}\n"
		# lsblk con espaciado para que no se vea junto
		printf "\n"
		lsblk -p -o NAME,SIZE,TYPE,FSTYPE
		printf "\n"
		
		printf "${ico_star}${greend} Formateando particion $TAREA${end}\n"
		printf "${ico_input} Escribe la ruta de la particion: ${end}"
		read -r PARTICION

		# Validacion de ruta (si esta vacio o no es un dispositivo de bloque)
		if [ -z "$PARTICION" ] || [ ! -b "$PARTICION" ]; then
			printf "${ico_error}${redl} Ruta de la particion seleccionada no valida.${end}\n"
			sleep $T_ERR
			# Al hacer continue, vuelve al inicio del while y refresca con menu_header
			continue
		fi

		# Pregunta de confirmacion
		printf "\n"
		if print_confirm "¿Estas seguro de formatear la particion?"; then
			printf "\n${ico_star} ${greend}Formateando $TAREA...${end}\n"
			
			# Ejecucion del comando (redirigido para mantener limpieza)
			if $COMANDO_BASE "$PARTICION" >/dev/null 2>&1; then
				printf "${ico_ok} ${greenl}La particion se formateo correctamente.${end}\n"
				sleep $T_INFO
				break # Sale del bucle de esta particion y vuelve al menu
			else
				printf "${ico_error} ${redl}Error al ejecutar el formateo.${end}\n"
				print_continue
				break
			fi
		else
			printf "${ico_warn} ${redd}Operacion cancelada por el usuario.${end}\n"
			sleep $T_INFO
			break # Vuelve al menu principal
		fi
	done
}

# MENU DE ACCIONES
while true; do
	menu_header
	print_title "PARTICIONES: FORMATEAR"

	printf "${gray}Detalles del disco seleccionado:${end}\n"
	lsblk -p -o NAME,SIZE,TYPE,FSTYPE
	printf "\n"

	printf "Selecciona una opcion para formatear la particion:\n"
	printf " 1) Formatear EFI\n"
	printf " 2) Formatear ROOT\n"
	printf " 3) Formatear JUEGOS\n"
	printf " 4) Formatear HDD\n"
	printf " 5) Modo Manual\n"
	printf " 6) Finalizar y continuar\n"
	
	print_ask
	read -r opt_part

	case $opt_part in
		1)
			exec_format "EFI" "mkfs.fat -F32"
			;;
		2)
			exec_format "ROOT" "mkfs.ext4 -F"
			;;
		3)
			exec_format "JUEGOS" "mkfs.f2fs -f -O extra_attr,inode_checksum,sb_checksum,compression"
			;;
		4)
			exec_format "HDD" "mkfs.ext4 -F"
			;;
		5)
			menu_header
			print_title "PARTICIONES: FORMATEAR"
			printf "${ico_warn}${redd} Entrando a la shell.${end}\n"
			printf "${ico_info}${redd} Escribe 'exit' o pulsa Ctrl+D para volver.${end}\n"

			/bin/bash --norc
			clear
			;;
		6)
			# Sale del bucle del menu para seguir con el script
			break
			;;
		*)
			print_novalid
			;;
	esac
done

# MENSAJE FINAL AL SALIR DEL MENU
menu_header
print_title "PARTICIONES: FORMATEAR"
printf "${ico_ok} ${greenl}Proceso de formateo finalizado.${end}\n"
print_continue
