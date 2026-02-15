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

# UTILIDAD AUXILIAR
pausa() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${blue}>>> Presiona [Intro] para continuar...${end}\n"
	read -r
}

# FUNCION PARA PEDIR OPCIONES
pregunta() {
	printf "\n${white}Elige una opcion:${end} "
}

# FUNCION ENCABEZADO
menu_header() {
	clear
	printf "${purple}==========================================${end}\n"
	printf "${purple}         INSTALADOR INTERACTIVO ARCH        ${end}\n"
	printf "${purple}==========================================${end}\n\n"
}

# FUNCION PARA TITULOS CENTRADOS
print_title() {
	local texto="$1"
	local ancho=42
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
	printf "${cyan}==========================================${end}\n"
}
