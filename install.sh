#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# DESCARGAR FUENTE  ---
# Definimos la ruta de la fuente parcheada
FONT_NAME="ter-u24n-nerd.psf.gz"
FONT_PATH="/usr/share/kbd/consolefonts/$FONT_NAME"
# URL directa del repositorio de Terroo (formato PSF para TTY)
URL="https://raw.githubusercontent.com/terroo/fonts/main/terminus-nerd/ter-u24n-nerd.psf.gz"

if [ ! -f "$FONT_PATH" ]; then
	# Descarga totalmente silenciosa
	curl -fsSL "$URL" -o "$FONT_PATH" &>/dev/null
	if [ -f "$FONT_PATH" ]; then
		setfont ter-u24n-nerd &>/dev/null
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
