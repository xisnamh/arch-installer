#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# DESCARGAR FUENTE  ---
# Definimos la ruta de la fuente parcheada
FONT_PATH="/usr/share/kbd/consolefonts/ter-u24n-nerd.psf.gz"

if [ ! -f "$FONT_PATH" ]; then
    printf "${yellow}[*] Configurando entorno visual (Nerd Font)...${end}\n"
    
    # Descarga con reintentos y soporte de certificados
    if curl -fsSL --connect-timeout 5 "https://github.com/terroo/font-terminus-nerd/raw/master/ter-u24n-nerd.psf.gz" -o "$FONT_PATH"; then
        setfont ter-u24n-nerd &>/dev/null
        printf "${green}[+] Fuente aplicada correctamente.${end}\n"
    else
        printf "${red}[!] No se pudo descargar la fuente. Usando fuente estándar.${end}\n"
        # Si falla la descarga, no intentamos setfont para evitar el error "Bad Input"
    fi
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
