#!/bin/bash

# ASEGURAR QUE LAS RUTAS RELATIVAS FUNCIONEN (./MODULES)
cd "$(dirname "$0")"

# CARGAR CONFIGURACION Y COLORES
source ./config.sh

# EJECUTAR MODULOS EN ORDEN

source ./modules/fuente.sh

source ./modules/discos.sh

#source ./modules/sistema.sh

#source ./modules/red.sh

#source ./modules/espejos.sh

#source ./modules/repositorioscachyos.sh

#source ./modules/llaves.sh

#source ./modules/discos.sh
