#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# DESCARGAR FUENTE  ---
# Definimos la ruta de la fuente parcheada
FONT_PATH="/usr/share/kbd/consolefonts/ter-u24n-nerd.psf.gz"

if [ ! -f "$FONT_PATH" ]; then
    printf "${yellow}[*] Preparando entorno visual...${end}\n"
    # Descargamos solo la fuente de consola (PSF) que soporta iconos
    # Esta es una versión de Terminus parcheada para TTY
    curl -sL "https://github.com/terroo/font-terminus-nerd/raw/master/ter-u24n-nerd.psf.gz" -o "$FONT_PATH"
    
    # Aplicamos la fuente
    setfont ter-u24n-nerd
    sleep 2
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
