#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# CARGAR CONFIGURACION Y COLORES
source ./config.sh

# EJECUTAR MODULOS EN ORDEN

source ./modules/fuente.sh #1

source ./modules/particiones.sh

source ./modules/sistema.sh #2

source ./modules/red.sh #3

source ./modules/espejos.sh #4

source ./modules/repositorioscachyos.sh #5

source ./modules/llaves.sh #6

source ./modules/discos.sh #7
