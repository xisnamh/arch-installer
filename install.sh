#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# DESCARGAR FUENTE NERD PARCHEADA
# Definimos la ruta de la fuente parcheada
FONT_NAME="ter-u24n-nerd.psf.gz"
FONT_PATH="/usr/share/kbd/consolefonts/$FONT_NAME"
URL="https://raw.githubusercontent.com/terroo/fonts/main/terminus-nerd/ter-u24n-nerd.psf.gz"

if [ ! -f "$FONT_PATH" ]; then
	printf "Descargando fuente desde: $URL\n"
	
	# Sin silencio para ver el progreso y errores de curl
	curl -fsSL "$URL" -o "$FONT_PATH"
	
	if [ -f "$FONT_PATH" ]; then
		printf "Aplicando fuente...\n"
		setfont ter-u24n-nerd
	else
		printf "Error: El archivo no se descargo correctamente.\n"
	fi
	
	printf "\nPresiona [Enter] para revisar los mensajes de arriba y continuar..."
	read -r
fi

# CARGAR CONFIGURACION Y COLORES
source ./config.sh

# EJECUTAR MODULOS EN ORDEN
menu_header
source ./modules/fuente.sh

menu_header
#source ./modules/discos_particiones.sh

source ./modules/preconfiguracion.sh

source ./modules/red.sh

source ./modules/reflector.sh

source ./modules/cachyos.sh

source ./modules/llaves.sh

source ./modules/discos_particiones.sh
