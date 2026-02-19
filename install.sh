#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# CARGAR CONFIGURACION Y COLORES
source ./config.sh

# EJECUTAR MODULOS EN ORDEN
menu_header
source ./modules/fuente.sh

menu_header
#source ./modules/discos_particiones.sh

source ./modules/preconfigurar.sh

source ./modules/red.sh

source ./modules/mirrorlist.sh

source ./modules/cachyos.sh

source ./modules/llaves.sh

source ./modules/discos.sh
