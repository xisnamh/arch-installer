#!/bin/bash

# COLORES ANSI
export blue="\033[0;36m"	# Azul suave		(titulo)
export white="\033[1;37m"	# Blanco		(subtitulo)
export gray="\033[1;30m"	# Gris			(texto secundario)
export greenl="\033[1;32m"	# Verde	brillante	(exito)
export greend="\033[0;32m"	# Verde	oscuro		(exito)

export redl="\033[1;31m"	# Rojo brillante	(alerta critica)
export redd="\033[0;31m"	# Rojo oscuro		(alerta critica)

export orange="\033[0;33m"	# Naranja		(aviso importante)
export yellow="\033[1;33m"	# Amarillo		(instrucciones)
				# color ?		(mensajes info)
export bluel="\033[1;36m"	# Azul electrico
export end="\033[0m"

# ICONOS
ico_ok="${greenl}[\u002b]${end}"	# [+] Ok 		(verde brillante)
ico_error="${redl}[\u00d7]${end}"	# [×] Error		(rojo brillante)
ico_info="${orange}[\u2139]${end}"	# [ℹ] Informacion	(rojo oscuro)
ico_warn="${white}[\u0021]${end}"	# [!] Peligro		(blanco)
ico_ques="${orange}[\u003f]${end}"	# [?] Confirmar		(naranja)
ico_star="${greend}[\u002a]${end}"	# [*] Asterisco 	(verde oscuro)
ico_prompt="${white}>${end}"		#  > Prompt		(blanco)
ico_input=">"				#  > input		(sin color)
ico_item="•"				#  • Item		(sin color)
ico_line="${gray}\u2500${end}"		#  ─ Linea horizontal

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
	local texto=" $1"		# Agregamos el espacio inicial al texto
	local len=${#texto}		# Medimos el texto (incluyendo ese espacio)
	local linea_largo=$((len + 1))	# La línea sera 1 caracter más larga

	printf "${white}%s${end}\n" "$texto"	# Imprimimos el titulo con su espacio inicial
	    
	printf "${white}%.0s─${end}" $(seq 1 $linea_largo)	# Dibujamos la línea usando un truco de printf para repetir el caracter
	    
	printf "\n" # Espacio para que no se pegue al contenido
}

# AVISO ERROR
print_warning_box() {
	local texto="$1"
	printf "${redl}${ico_error} Error: ${texto}${end}\n"
}

print_warning_end() {
	printf "\n"
}

# FUNCION AVISO INFORMATIVO
print_info_box() {
	local texto="$1"
	printf "${redd}${ico_info} ${texto}${end}\n"
}

print_info_end() {
	printf "\n"
}

# FUNCION OPCIONES
print_ask() {
	printf "\n${white}${ico_prompt} Elige una opcion:${end} "
}

# FUNCION VALIDACION
print_confirm() {
	local pregunta="$1"
	local respuesta
	while true; do
		printf "${ico_input} ${white}$pregunta (s/n): ${end}"
		read -r respuesta
		case "$respuesta" in
			[Ss]) return 0 ;;
			[Nn]) return 1 ;;
			*)
				# Sube una linea, borra el error y permite reintentar (Igual que antes)
				printf "\033[1A\033[K${ico_error} ${redl}Opcion no valida${end}"
				sleep $T_ERR
				printf "\r\033[K"
				;;
		esac
	done
}

# FUNCION CONTINUAR
print_continue() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${white}${ico_input}${ico_input} Presiona [Intro] para continuar...${end}\n"
	read -r
}

# FUNCION VOLVER
print_back() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${white}${ico_input}${ico_input} Presiona [Intro] para volver...${end}\n"
	read -r
}

# DETECCION ENTORNO VIRTUAL
export IS_VM=false
if systemd-detect-virt > /dev/null 2>&1; then
	export IS_VM=true
	export VIRT_TYPE=$(systemd-detect-virt)
fi

