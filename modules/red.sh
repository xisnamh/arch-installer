#!/bin/bash

# 5. RED
while true; do
	menu_header
	print_title "RED"

	if ping -c 1 google.com > /dev/null 2>&1; then
		printf "${ico_ok} ${greenl}Hay conexion a internet detectada.${end}\n"
	else
			printf "${ico_error} ${redl}No hay conexion a internet detectada.${end}\n"
	fi

	printf "\n${gray}Estado actual de las interfaces:${end}\n"
		# Procesamos la informacion pero imprimimos sin etiquetas de color
		ip -4 -brief address show scope global | while read -r iface status ip_mask; do
		# Limpiamos el /24 de la IP
		clean_ip=$(echo $ip_mask | cut -d/ -f1)
		
		# El %-10s y %-8s mantienen las columnas alineadas
		printf "%-10s  %-8s  %s\n" "$iface" "$status" "$clean_ip"
	done
	printf "\n"

	WIFI_DEVICES=$(iwctl device list | grep -E "wlan|p2p")

	printf "${white}Selecciona como configurar el wifi:\n"
	if [ -z "$WIFI_DEVICES" ]; then
		printf " ${orange}1) Modo Asistido (No se detectan tarjetas wifi)${end}\n"
	else
		printf " 1) Modo Asistido\n"
	fi
	printf " 2) Modo Manual\n"
	printf " 3) Saltar / Ya tengo internet\n"

	print_ask
	read wifi_opt

	case $wifi_opt in
		1)
			if [ -z "$WIFI_DEVICES" ]; then
				printf "${ico_error} ${red}Error: No se detecto hardware wifi${end}\n"
				sleep "$T_ERR"
				continue
			fi
			menu_header
			print_title "MODO ASISTIDO"
			iwctl device list
			printf "\n"

			# BUCLE ADAPTADOR
			while true; do
				printf "${white}${ico_input} Escribe tu adaptador (ej: wlan0) o 'q' para volver: ${end}"
				read -r ADAPTADOR
				[[ "$ADAPTADOR" == "q" ]] && break
				if ip link show "$ADAPTADOR" > /dev/null 2>&1; then
					break
				else
					print_warning_box "Adaptador no valido"
					sleep $T_ERR
				fi
			done
			[[ "$ADAPTADOR" == "q" ]] && continue

			# BUCLE CONEXION
			while true; do
				printf "${ico_info} ${blue}Escaneando redes...${end}\n"
				iwctl station "$ADAPTADOR" scan
				sleep $T_INFO
				iwctl station "$ADAPTADOR" get-networks
				
				printf "\n${white}${ico_input} SSID ('r' re-escanear, 'q' volver): ${end}"
				read -r SSID
				[[ "$SSID" == "q" ]] && break
				[[ "$SSID" == "r" ]] && continue

				printf "${ico_star} ${blue}Intentando conectar a ${cyan}$SSID${end}...\n"
				iwctl station "$ADAPTADOR" connect "$SSID"

				printf "${ico_info} ${blue}Verificando estado...${end}\n"
				sleep $T_WAIT # Tiempo para handshake y DHCP

				WIFI_STATE=$(iwctl station "$ADAPTADOR" show | grep State | awk '{print $2}')

				if [[ "$WIFI_STATE" == "connected" ]]; then
					if ping -I "$ADAPTADOR" -c 1 8.8.8.8 > /dev/null 2>&1; then
						printf "${ico_ok} ${green}Conexión establecida en $ADAPTADOR.${end}\n"
						sleep $T_INFO
						break 2
					else
						print_warning_box "Conectado al wifi, pero sin internet"
						iwctl station "$ADAPTADOR" disconnect > /dev/null 2>&1
					fi
				else
					print_warning_box "Error de autenticacion"
					iwctl station "$ADAPTADOR" disconnect > /dev/null 2>&1
				fi

				printf "\n${ico_warn} ${yellow}Presiona una tecla para reintentar... ${end}"
				read -n 1
				menu_header
				iwctl station "$ADAPTADOR" get-networks
			done
			;;
		2)
			while true; do
				menu_header
				print_title "MENU MANUAL DE RED"
				printf " 1) Ver comandos de Iwctl\n"
				printf " 2) Entrar a Iwctl \n"
				printf " 3) Volver al menu de seleccion\n"
				printf " 4) Salir y continuar la instalacion\n"
				
				print_ask
				read -r manual_opt

				case $manual_opt in
					1)
						menu_header
						print_title "GUIA DE COMANDOS IWCTL"
						printf "${ico_line}${gray} Dispositivos${end}\n"
						printf "  device list                                     - Lista tarjetas\n"
						printf "  device <wlan> set-property Powered on | off     - ON/OFF tarjeta\n"
						printf "  device <wlan> show                              - Detalles\n\n"
						printf "${ico_line}${gray} Escaneo y Estaciones${end}\n"
						printf "  station list                                    - Dispositivos\n"
						printf "  station <wlan> scan                             - Buscar (Obligatorio)\n"
						printf "  station <wlan> get-networks                     - Ver SSIDs\n"
						printf "  station <wlan> connect <SSID>                   - Conectar\n"
						printf "  station <wlan> show                             - Ver IP y Señal\n\n"
						printf "${ico_line}${gray} Gestion de Redes Conocidas${end}\n"
						printf "  known-networks list                             - Listar guardadas\n"
						printf "  known-networks <SSID> forget                    - Borrar guardada\n\n"
						printf "${ico_line}${gray} Modos Especiales${end}\n"
						printf "  ap <wlan> start-profile <nombre>                - Crear Punto Acceso\n"
						printf "  ad-hoc <wlan> start <nombre> <pass>             - Punto a punto\n"
						print_back
						;;
					2)
						printf "\n"
						printf "${ico_info} ${blue}Entrando en iwctl... Escribe 'exit' para volver.${end}\n"
						iwctl
						;;
					3)
						break
						;;
					4)
						break 2
						;;
					*)
						print_warning_box "Opcion no valida"
						sleep $T_ERR
						;;
				esac
			done
			;;
		3)
			break
			;;
		*)
			print_warning_box "Elige 1, 2 o 3"
			sleep $T_ERR
			;;
	esac
done

print_continue
