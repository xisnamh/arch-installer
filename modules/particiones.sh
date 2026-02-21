#!/bin/bash

# 8. FORMATEAR PARTICIONES

# Funcion para gestionar la entrada y ejecucion de cada comando de formateo
ejecutar_formateo() {
	local TAREA="$1"
	local COMANDO_BASE="$2"
	local PARTICION

	while true; do
		menu_header
		print_title "PARTICIONES"
		printf "${gray}Configurando las particiones:${end}\n"
		lsblk -p -o NAME,SIZE,TYPE,FSTYPE
		printf "\n"
		
		print_info "Tarea actual: $TAREA"
		printf "${ico_input} Escribe la ruta para (/dev/...): ${end}"
		read -r PARTICION

		if [ -z "$PARTICION" ] || [ ! -b "$PARTICION" ]; then
			printf "${ico_error}${redl} Ruta de la particion seleccionada no valida.${end}\n"
			sleep $T_ERR
			continue
		fi

		if print_confirm "¿Estas seguro de formatear $PARTICION?"; then
			printf "\n${ico_star} ${greend}${TAREA}...${end}\n"
			
			# Ejecucion del comando
			if $COMANDO_BASE "$PARTICION"; then
				printf "${ico_ok} ${greenl}Completado.${end}\n"
				sleep $T_INFO
				break
			else
				printf "${ico_error} ${redl}Error al ejecutar el comando.${end}\n"
				print_continue
			fi
		else
			printf "${ico_warn} ${redd}Operacion cancelada por el usuario.${end}\n"
			sleep $T_INFO
			break
		fi
	done
}

# --- INICIO DEL PROCESO DE FORMATEO ---

# 1. PARTICION EFI
ejecutar_formateo "Formateando particion EFI (FAT32)" "mkfs.fat -F32"

# 2. PARTICION ROOT
ejecutar_formateo "Formateando particion ROOT (EXT4)" "mkfs.ext4 -F"

# 3. PARTICION JUEGOS
ejecutar_formateo "Formateando particion JUEGOS (F2FS)" "mkfs.f2fs -f -O extra_attr,inode_checksum,sb_checksum,compression"

# 4. PARTICION HDD
ejecutar_formateo "Formateando particion HDD (EXT4)" "mkfs.ext4 -F"

# --- FINALIZACION ---
menu_header
print_title "PARTICIONES"
printf "${ico_ok} ${greenl}Configuracion de particiones finalizada correctamente.${end}\n"
print_continue
