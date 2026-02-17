#!/bin/bash

# COLORES ANSI
export purple="\e[38;5;141m"	# Púrpura pastel (Encabezados)
export cyan="\e[38;5;81m"	# Azul cielo/Cian (Títulos)
export red="\e[38;5;196m"	# Rojo vibrante (Alertas críticas)
export orange="\e[38;5;208m"	# Naranja puro (Avisos importantes)
export lime="\e[38;5;118m"	# Verde lima (Éxitos)
export gold="\e[38;5;214m"	# Oro/Amarillo (Instrucciones)
export blue="\e[38;5;33m"	# Azul eléctrico (Mensajes info)
export white="\e[38;5;255m"	# Blanco puro
export gray="\e[38;5;244m"	# Gris (Texto secundario)
export silver="\e[38;5;250m"	# Gris platino suave para tablas
export end="\e[0m"

# COMPATIBILIDAD COLORES CON TUS SCRIPTS ANTIGUOS
export green="$lime"
export yellow="$gold"

# ICONOS
ico_ok="${lime}[\u221a]${end}"		# [√] Ok (verde)
ico_error="${red}[\u00d7]${end}"	# [×] Error (rojo)
ico_info="${blue}[\u2139]${end}"	# [ℹ] Informacion (azul)
ico_warn="${yellow}[\u0021]${end}"	# [!] Peligro (amarillo)
ico_ques="${orange}[\u003f]${end}"	# [?] Confirmar (naranja)
ico_star="${gold}[\u002a]${end}"	# [*] Asterisco (oro)
ico_plus="${lime}[\u002b]${end}"	# [+] Instalar (verde)
ico_input=">"				#  > Prompt
ico_item="${white}\u2022${end}"		#  • Item (blanco)
ico_line="${silver}\u2500${end}"	#  ─ Linea horizontal

# VARIABLES TIEMPO
T_ERR=1 	# Tiempo para errores (Opcion no valida)
T_INFO=2	# Tiempo para mensajes informativos o de exito
T_WAIT=5	# Tiempo para esperas de red/sincronizacion

# FUNCION ENCABEZADO
menu_header() {
	clear
	printf "\n"
	printf "${purple}===============================================${end}\n"
	printf "\n"
	printf "${purple}          INSTALADOR INTERACTIVO ARCH          ${end}\n"
	printf "\n"
	printf "${purple}===============================================${end}\n"
	printf "\n"
	printf "\n"
}

# FUNCION TITULOS CENTRADOS
print_title() {
	local texto="$1"
	local ancho=47
	local len=${#texto}
	
	# Si el texto es mas largo que el ancho, lo recortamos o ajustamos
	if [ "$len" -ge "$ancho" ]; then
		printf "${cyan}%s${end}\n" "$texto"
	else
		local total_espacios=$(( ancho - len ))
		local esp_izq=$(( total_espacios / 2 ))
		# Generamos los espacios dinamicamente con tabs para la indentacion
		printf "${cyan}%*s%s%*s${end}\n" "$esp_izq" "" "$texto" "$((ancho - len - esp_izq))" ""
	fi
	printf "${cyan}===============================================${end}\n"
	printf "\n"
}

# FUNCION AVISO FALLIDO
print_warning_box() {
	local texto=" ${ico_error} $1 "
	local ancho=47
	local len=$(echo -e "$texto" | sed "s/\x1B\[[0-9;]*[mK]//g" | wc -c)
	
	local total_guiones=$(( ancho - len ))
	local guiones_izq=$(( total_guiones / 2 ))
	local guiones_der=$(( ancho - len - guiones_izq ))

	printf "${red}"
	printf '─%.0s' $(seq 1 $guiones_izq)
	printf "${end}${texto}${red}" # Aquí el texto ya trae su icono con corchetes
	printf '─%.0s' $(seq 1 $guiones_der)
	printf "${end}\n"
}

print_warning_end() {
	local ancho=47
	printf "${red}"
	printf '─%.0s' $(seq 1 $ancho)
	printf "${end}\n"
}

# FUNCION AVISO INFORMATIVO
print_info_box() {
	local texto=" ${ico_info} $1 "
	local ancho=47
	local len=$(echo -e "$texto" | sed "s/\x1B\[[0-9;]*[mK]//g" | wc -c)
	
	local total_guiones=$(( ancho - len ))
	local guiones_izq=$(( total_guiones / 2 ))
	local guiones_der=$(( ancho - len - guiones_izq ))

	printf "${gold}"
	printf '─%.0s' $(seq 1 $guiones_izq)
	printf "${end}${texto}${gold}"
	printf '─%.0s' $(seq 1 $guiones_der)
	printf "${end}\n"
}

print_info_end() {
	local ancho=47
	printf "${gold}"
	printf '─%.0s' $(seq 1 $ancho)
	printf "${end}\n"
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

