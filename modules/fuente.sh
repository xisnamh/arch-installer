#!/bin/bash

# Definiciones rápidas para la demostración
R0="\033[0;31m"    # Rojo normal
R1="\033[1;31m"    # Rojo brillante
R2="\033[2;31m"    # Rojo oscuro/tenue
R3="\033[3;31m"    # Rojo cursiva (si la TTY lo soporta)
R4="\033[4;31m"    # Rojo subrayado
R5="\033[5;31m"    # Rojo parpadeante
R7="\033[7;31m"    # Rojo invertido
R91="\033[0;91m"   # Rojo alta intensidad
RBW="\033[41;1;37m" # Fondo rojo, letra blanca
RBN="\033[41;30m"   # Fondo rojo, letra negra
RBY="\033[31;43m"   # Letra roja, fondo amarillo
RBB="\033[31;44m"   # Letra roja, fondo azul
RSU="\033[1;4;31m"  # Rojo negrita y subrayado
RIT="\033[2;3;31m"  # Rojo tenue y cursiva
END="\033[0m"

echo -e "${R0}1. Opcion no valida. Reintente.${END}"
echo -e "${R1}2. ERROR CRITICO: No se detecto el disco /dev/sda.${END}"
echo -e "${R2}3. (Aviso) El repositorio multilib esta desactivado.${END}"
echo -e "${R3}4. La descarga de la mirrorlist ha fallado.${END}"
echo -e "${R4}5. ATENCION: El disco seleccionado tiene particiones activas.${END}"
echo -e "${R5}6. ¡PELIGRO! Se borraran todos los datos del NVMe.${END}"
echo -e "${R7}7.  CONFIRMACION REQUERIDA: Escriba 'BORRAR'  ${END}"
echo -e "${R91}8. La temperatura del procesador es muy elevada.${END}"
echo -e "${RBW}9. ERROR DE HARDWARE: Fallo en la suma de comprobacion.${END}"
echo -e "${RBN}10.  MONTAJE FALLIDO: La particion /mnt/boot no existe.  ${END}"
echo -e "${RBY}11. ADVERTENCIA: La firma PGP del paquete no es valida.${END}"
echo -e "${RBB}12. Error de red: No se pudo conectar al servidor NTP.${END}"
echo -e "${RSU}13. PERMISO DENEGADO: Ejecute el script como root.${END}"
echo -e "${RIT}14. El usuario ha cancelado la instalacion de CachyOS.${END}"
echo -e "${R0}15. Fin del reporte de errores.${END}"

# 0. LOCALES PARA LA SESION ACTUAL
# Soporte para caracteres utf-8
echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen
locale-gen > /dev/null 2>&1

# Establecer idioma español a la terminal
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# Funcion interna para no repetir ccdigo del menu
font_menu() {
	clear
	menu_header
	print_title "FUENTE (TTY)"
	printf "${purple}Selecciona un tamaño de letra para la consola:${end}\n"
	printf " 1) Normal   (Tamaño estandar)\n"
	printf " 2) Mediana  (Recomendado 1080p)\n"
	printf " 3) Grande   (Recomendado 2K/4K)\n"
	printf " 4) Saltar / No cambiar\n"
}

# 1. CONFIGURACION DE FUENTE (TTY)
while true; do
	font_menu
	print_ask
	read -r font_opt

	case $font_opt in
		1) FONT="ter-918b" ;;
		2) FONT="ter-924b" ;;
		3) FONT="ter-932b" ;;
		4) break ;;
		*)
			printf "${ico_error} ${red}Opcion no valida${end}\n"
			sleep $T_ERR
			continue
			;;
	esac

	# Aplicamos la fuente para que el usuario vea el cambio
	setfont "$FONT" 2>/dev/null

	# Volvemos a pintar todo el menu con la fuente nueva antes de lanzar el print_confirm
	font_menu
	printf "\n"

	if print_confirm "Te gusta este tamaño?"; then
		printf "${ico_ok} ${green}Fuente configurada correctamente.${end}\n"
		sleep $T_INFO
		break
	else
		# Si no le gusta, restauramos la fuente por defecto y vuelve al inicio del bucle
		setfont lat9w-16 2>/dev/null
	fi
done
