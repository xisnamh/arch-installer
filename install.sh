#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS (./MODULES) FUNCIONEN DESDE CUALQUIER CARPETA
cd "$(dirname "$0")"

# CARGAR CONFIGURACION Y COLORES
source ./config.sh

# EJECUTAR MODULOS EN ORDEN
menu_header
source ./modules/font.sh

menu_header
source ./modules/system.sh

source ./modules/network.sh

source ./modules/mirrors.sh

source ./modules/cachyos.sh

printf "${green}##########################################${end}\n"
printf "${green}#    FASE DE PRE-INSTALACION COMPLETA    #${end}\n"
printf "${green}##########################################${end}\n"
