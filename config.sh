#!/bin/bash

# COLORES
green="\e[32m"
red="\e[31m"
blue="\e[34m"
yellow="\e[33m"
purple="\e[35m"
cyan="\e[36m"
white="\e[37m"
end="\e[0m"

# VARIABLES TIEMPO
T_ERR=1 	# Tiempo para errores (Opcion no valida)
T_INFO=2	# Tiempo para mensajes informativos o de exito
T_WAIT=5	# Tiempo para esperas de red/sincronizacion

# FUNCION ENCABEZADO
menu_header() {
	clear
	printf "\n"
	printf "${purple}===============================================${end}\n"
	printf "${purple}          INSTALADOR INTERACTIVO ARCH          ${end}\n"
	printf "${purple}===============================================${end}\n"
	printf "\n"
	printf "\n"
}

# FUNCION TITULOS CENTRADOS
print_title() {
	local texto="$1"
	local ancho=47
	local len=${#texto}
	
	# Si el texto es mas largo que el ancho, lo recortamos o ajustamos
	if [ "$len" -ge "$ancho" ]; then
		printf "${cyan}%s${end}\n" "$texto"
	else
		local total_espacios=$(( ancho - len ))
		local esp_izq=$(( total_espacios / 2 ))
		# Generamos los espacios dinamicamente con tabs para la indentacion
		printf "${cyan}%*s%s%*s${end}\n" "$esp_izq" "" "$texto" "$((ancho - len - esp_izq))" ""
	fi
	printf "${cyan}===============================================${end}\n"
}

# FUNCION PEDIR OPCIONES
pregunta() {
	printf "\n${white}Elige una opcion:${end} "
}

# FUNCION VALIDACION
confirmar() {
	local pregunta="$1"
	local respuesta
	while true; do
		printf "${yellow}$pregunta (s/n): ${end}"
		read -r respuesta
		case "$respuesta" in
			[Ss]) return 0 ;;
			[Nn]) return 1 ;;
			*)
				# Sube una linea, borra el error y permite reintentar (Igual que antes)
				printf "\e[1A\e[K${red}[!] Opcion no valida.${end}"
				sleep 1; printf "\r\e[K"
				;;
		esac
	done
}

# UTILIDAD AUXILIAR
pausa() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${blue}>>> Presiona [Intro] para continuar...${end}\n"
	read -r
}


