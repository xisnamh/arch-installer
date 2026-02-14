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

# UTILIDAD AUXILIAR DEL SCRIPT
pausa() {
	printf "\n${blue}>>> Presiona [Intro] para continuar con el siguiente paso...${end}\n"
	read
}

# FUNCION ENCABEZADO
menu_header() {
	clear
	printf "${purple}==========================================${end}\n"
	printf "${purple}         INSTALADOR INTERACTIVO ARCH        ${end}\n"
	printf "${purple}==========================================${end}\n\n\n\n"
}
