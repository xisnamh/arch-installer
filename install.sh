#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS (./MODULES) FUNCIONEN DESDE CUALQUIER CARPETA
cd "$(dirname "$0")"

# CARGAR CONFIGURACION Y COLORES
source ./config.sh

# EJECUTAR MODULOS EN ORDEN
menu_header
source ./modules/fuente.sh

menu_header
source ./modules/sistema.sh

source ./modules/red.sh

source ./modules/reflector.sh

source ./modules/cachyos.sh

source ./modules/llaves.sh

printf "${green}##########################################${end}\n"
printf "${green}#    FASE DE PRE-INSTALACION COMPLETA    #${end}\n"
printf "${green}##########################################${end}\n"
