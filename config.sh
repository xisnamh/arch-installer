#!/bin/bash

# COLORES ANSI
export blue="\e[38;5;81m"	# Azul suave		(titulo)
export white="\e[38;5;255m"	# Blanco puro		(subtitulo)
export red="\e[38;5;196m"	# Rojo			(alerta critica)
export orange="\e[38;5;216m"	# Naranja		(aviso importante)
export lime="\e[38;5;118m"	# Verde lima		(exito)
export gold="\e[38;5;214m"	# Oro/Amarillo		(instrucciones)
export cyan="\e[38;5;33m"	# Azul eléctrico	(mensajes info)

export gray="\e[38;5;244m"	# Gris			(texto secundario)
export silver="\e[38;5;250m"	# Gris platino
export end="\e[0m"

# COMPATIBILIDAD COLORES CON TUS SCRIPTS ANTIGUOS
export green="$lime"
export yellow="$gold"

# ICONOS
ico_ok="${lime}[\u221a]${end}"		# [√] Ok 		(verde)
ico_error="${red}[\u00d7]${end}"	# [×] Error		(rojo)
ico_info="${blue}[\u2139]${end}"	# [ℹ] Informacion	(azul)
ico_warn="${yellow}[\u0021]${end}"	# [!] Peligro		(amarillo)
ico_ques="${orange}[\u003f]${end}"	# [?] Confirmar		(naranja)
ico_star="${gold}[\u002a]${end}"	# [*] Asterisco 	(oro)
ico_plus="${lime}[\u002b]${end}"	# [+] Instalar		(verde)
ico_input=">"				#  > Prompt
ico_item="${white}\u2022${end}"		#  • Item		(blanco)
ico_line="${silver}\u2500${end}"	#  ─ Linea horizontal

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
	printf "Este es el \033[0;34mAzul Mate (0;34)\033[0m para el instalador\n"
printf "Este es el \033[1;34mAzul Brillante (1;34)\033[0m para el instalador\n"
printf "Este es el \033[0;36mCian Mate (0;36)\033[0m para el instalador\n"
printf "Este es el \033[1;36mCian Brillante (1;36)\033[0m para el instalador\n"
}

# SUBTITULO
print_title() {
	local texto=" $1"		# Agregamos el espacio inicial al texto
	local len=${#texto}		# Medimos el texto (incluyendo ese espacio)
	local linea_largo=$((len + 1))	# La línea será 1 carácter más larga

	# Imprimimos el título con su espacio inicial
	printf "${white}%s${end}\n" "$texto"
	    
	# Dibujamos la línea usando un truco de printf para repetir el carácter
	printf "${white}%.0s─${end}" $(seq 1 $linea_largo)
	    
	printf "\n" # Espacio para que no se pegue al contenido
}

# AVISO ERROR
print_warning_box() {
	local texto="$1"
	printf "${red}${ico_error} Error:${end} ${white}${texto}${end}\n"
}

print_warning_end() {
	printf "\n"
}

# FUNCION AVISO INFORMATIVO
print_info_box() {
	local texto="$1"
	printf "${blue}${ico_info} Info:${end} ${white}${texto}${end}\n"
}

print_info_end() {
	printf "\n"
}

# FUNCION OPCIONES
print_ask() {
	printf "\n${white}${ico_input} Elige una opcion:${end} "
}

# FUNCION VALIDACION
print_confirm() {
	local pregunta="$1"
	local respuesta
	while true; do
		printf "${ico_warn} ${yellow}$pregunta (s/n): ${end}"
		read -r respuesta
		case "$respuesta" in
			[Ss]) return 0 ;;
			[Nn]) return 1 ;;
			*)
				# Sube una linea, borra el error y permite reintentar (Igual que antes)
				printf "\e[1A\e[K${ico_error} ${red}Opcion no valida${end}"
				sleep $T_ERR
				printf "\r\e[K"
				;;
		esac
	done
}

# FUNCION CONTINUAR
print_continue() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${blue}${ico_input}${ico_input} Presiona [Intro] para continuar...${end}\n"
	read -r
}

# FUNCION VOLVER
print_back() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${blue}${ico_input}${ico_input} Presiona [Intro] para volver...${end}\n"
	read -r
}

# DETECCION ENTORNO VIRTUAL
export IS_VM=false
if systemd-detect-virt > /dev/null 2>&1; then
	export IS_VM=true
	export VIRT_TYPE=$(systemd-detect-virt)
fi

