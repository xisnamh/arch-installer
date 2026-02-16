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
ico_ok=$(printf '\u2714')	# ✔
ico_error=$(printf '\u2718')	# ✖
ico_warning=$(printf '\u26a0')	# ⚠
ico_info=$(printf '\u2139')	# ℹ
ico_input=$(printf '\u276f')	# ❯
ico_next=$(printf '\u00bb')	# »

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

# FUNCION AVISO IMPORTANTE
print_warning_box() {
	local texto=" $1 " # Añadimos un espacio antes y después del texto
	local ancho=47
	local len=${#texto}
	
	# Calculamos cuántos guiones poner a cada lado
	local total_guiones=$(( ancho - len ))
	local guiones_izq=$(( total_guiones / 2 ))
	local guiones_der=$(( ancho - len - guiones_izq ))

	# Imprimimos la línea decorativa con el texto separado por espacios
	printf "${red}"
	printf '─%.0s' $(seq 1 $guiones_izq)
	printf "${red}%s${red}" "$texto"
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
	local texto=" $1 "
	local ancho=47
	local len=${#texto}
	
	local total_guiones=$(( ancho - len ))
	local guiones_izq=$(( total_guiones / 2 ))
	local guiones_der=$(( ancho - len - guiones_izq ))

	printf "${gold}"
	printf '─%.0s' $(seq 1 $guiones_izq)
	printf "${gold}%s${gold}" "$texto"
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
pregunta() {
	printf "\n${white}${ico_input} Elige una opcion:${end} "
}

# FUNCION VALIDACION
confirmar() {
	local pregunta="$1"
	local respuesta
	while true; do
		printf "${yellow}${ico_warning} $pregunta (s/n): ${end}"
		read -r respuesta
		case "$respuesta" in
			[Ss]) return 0 ;;
			[Nn]) return 1 ;;
			*)
				# Sube una linea, borra el error y permite reintentar (Igual que antes)
				printf "\e[1A\e[K${red}${ico_error} Opcion no valida.${end}"
				sleep 1; printf "\r\e[K"
				;;
		esac
	done
}

# FUNCION CONTINUAR
pausa() {
	# Usar -r en read es buena practica para evitar que escape caracteres
	printf "\n${blue}${ico_next} Presiona [Intro] para continuar...${end}\n"
	read -r
}

# DETECCION ENTORNO VIRTUAL
export IS_VM=false
if systemd-detect-virt > /dev/null 2>&1; then
	export IS_VM=true
	export VIRT_TYPE=$(systemd-detect-virt)
fi

