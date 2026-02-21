#!/bin/bash

# COLORES ANSI
export blue="\033[0;36m"	# Azul suave		(titulo)
export white="\033[1;37m"	# Blanco		(subtitulo)
export gray="\033[1;30m"	# Gris			(pregunta principal)
export greend="\033[0;32m"	# Verde	oscuro		(configurando)
export greenl="\033[1;32m"	# Verde	brillante	(configurado)
export redl="\033[1;31m"	# Rojo brillante	(error)
export redd="\033[0;31m"	# Rojo oscuro		(aviso importante/informacion/intrucciones)
export end="\033[0m"

# ICONOS
ico_ok="${greenl}[\u002b]${end}"	# [+] Ok		(verde brillante)
ico_error="${redl}[\u00d7]${end}"	# [×] Error		(rojo brillante)
ico_info="${redd}[\u2139]${end}"	# [ℹ] Informacion	(rojo oscuro)
ico_warn="${redd}[\u0021]${end}"	# [!] Importante	(rojo oscuro)
ico_ques="${redd}[\u003f]${end}"	# [?] Confirmar		(rojo oscuro)
ico_star="${greend}[\u002a]${end}"	# [*] Configurando 	(verde oscuro)
ico_input=">"				#  >  Input		(sin color)
ico_item="•"				#  •  Item		(sin color)

# VARIABLES TIEMPO
T_ERR=1 	# Tiempo para errores
T_INFO=2	# Tiempo para mensajes informativos o de exito
T_WAIT=5	# Tiempo para espera de red/sincronizacion

# TITULO
menu_header() {
	clear
	printf "\n"
	printf "\n"
	printf "${blue}─────────────────────${end}\n"
	printf "${blue} ARCH LINUX INSTALAR ${end}\n"
	printf "${blue}─────────────────────${end}\n"
	printf "\n"
	printf "\n"
}

# SUBTITULO
print_title() {
	local texto=" $1"					# Agregamos el espacio inicial al texto
	local len=${#texto}					# Medimos el texto (incluyendo ese espacio)
	local linea_largo=$((len + 1))				# La línea sera 1 caracter más larga

	printf "${white}%s${end}\n" "$texto"			# Imprimimos el titulo con su espacio inicial
	    
	printf "${white}%.0s─${end}" $(seq 1 $linea_largo)	# Dibujamos la línea usando un truco de printf para repetir el caracter
	    
	printf "\n" 						# Espacio para que no se pegue al contenido
}

# AVISO ERROR
print_error() {
	local texto="$1"
	printf "${ico_error} ${redl} Error: ${texto}${end}"
	sleep $T_ERR
	printf "\r\033[K\033[1A\r\033[K"
}

print_error_end() {
	printf "\n"
}

# AVISO OPCION NO VALIDA
print_novalid() {
	local texto="$1"
	printf "${ico_error} ${redl}Opcion no valida${end}"
	sleep $T_ERR
	printf "\r\033[K\033[1A\r\033[K"
}

# FUNCION AVISO INFORMATIVO
print_info() {
	local texto="$1"
	printf "${ico_info} ${redd}${texto}${end}\n"
}

# FUNCION OPCIONES
print_ask() {
	printf "\n${ico_input} Elige una opcion: ${end}"
}

# FUNCION VALIDACION
print_confirm() {
	local pregunta="$1"
	local respuesta
	while true; do
		printf "${ico_input} $pregunta (s/n): ${end}"
		read -r respuesta || { printf "\r\033[K"; continue; } # Si se pulsa ctrl+d, refresa la pregunta
		case "$respuesta" in
			[Ss]) return 0 ;;
			[Nn]) return 1 ;;
			*)
				print_novalid
				;;
		esac
	done
}

# FUNCION CONTINUAR
print_continue() {
	# Usar -r en read para evitar que escape caracteres
	printf "\n${white}${ico_input}${ico_input} Presiona [Intro] para continuar...${end}\n"
	read -r
}

# FUNCION VOLVER
print_back() {
	# Usar -r en read para evitar que escape caracteres
	printf "\n${white}${ico_input}${ico_input} Presiona [Intro] para volver...${end}\n"
	read -r
}

# DETECCION ENTORNO VIRTUAL
export IS_VM=false
if systemd-detect-virt > /dev/null 2>&1; then
	export IS_VM=true
	export VIRT_TYPE=$(systemd-detect-virt)
fi

