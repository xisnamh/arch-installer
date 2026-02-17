#!/bin/bash

# 5. RED
while true; do
	menu_header
	print_title "CONFIGURACION DE RED"

	if ping -c 1 google.com > /dev/null 2>&1; then
		printf "${green}[!] ¡Ya tienes conexion a Internet!${end}\n"
	else
		printf "${red}[!] No hay conexion detectada.${end}\n"
	fi

	printf "\n${blue}Estado actual de las interfaces:${end}\n"
	ip -brief address show scope global
	printf "\n"

	WIFI_DEVICES=$(iwctl device list | grep -E "wlan|p2p")

	printf "Selecciona como configurar el wifi:\n"
	if [ -z "$WIFI_DEVICES" ]; then
		printf " ${red}1) Modo Asistido (No se detectan tarjetas wifi)${end}\n"
	else
		printf " 1) Modo Asistido\n"
	fi
	printf " 2) Modo Manual\n"
	printf " 3) Saltar / Ya tengo internet\n"

	pregunta
	read wifi_opt

	case $wifi_opt in
		1)
			if [ -z "$WIFI_DEVICES" ]; then
				printf "${red}[!] Error: No se detecto hardware WiFi.${end}\n"
				sleep $T_INFO
				continue
			fi
			menu_header
			printf "${blue}--- MODO ASISTIDO ---${end}\n"
			iwctl device list
			printf "\n"

			# BUCLE ADAPTADOR
			while true; do
				printf "Escribe tu adaptador (ej: wlan0) o 'q' para volver: "
				read ADAPTADOR
				[[ "$ADAPTADOR" == "q" ]] && break
				if ip link show "$ADAPTADOR" > /dev/null 2>&1; then
					break
				else
					printf "${red}[!] Adaptador no valido.${end}\n"
					sleep $T_ERR
				fi
			done
			[[ "$ADAPTADOR" == "q" ]] && continue

			# BUCLE CONEXION
			while true; do
				printf "${blue}Escaneando redes...${end}\n"
				iwctl station "$ADAPTADOR" scan
				sleep $T_INFO
				iwctl station "$ADAPTADOR" get-networks
				printf "\nSSID ('r' re-escanear, 'q' volver): "
				read SSID
				[[ "$SSID" == "q" ]] && break
				[[ "$SSID" == "r" ]] && continue

				printf "Intentando conectar a ${cyan}$SSID${end}...\n"

				# Intentamos conectar
				iwctl station "$ADAPTADOR" connect "$SSID"

				printf "${blue}Verificando estado y conectividad...${end}\n"
				sleep $T_WAIT # Tiempo para handshake y DHCP

				WIFI_STATE=$(iwctl station "$ADAPTADOR" show | grep State | awk '{print $2}')

				if [[ "$WIFI_STATE" == "connected" ]]; then
					if ping -I "$ADAPTADOR" -c 1 8.8.8.8 > /dev/null 2>&1; then
						printf "${green}[+] ¡Conectado y con internet real en $ADAPTADOR!${end}\n"
						sleep $T_INFO
						break 2
					else
						printf "${red}[!] Conectado al WiFi, pero sin internet (Fallo DHCP).${end}\n"
						iwctl station "$ADAPTADOR" disconnect > /dev/null 2>&1
					fi
				else
					printf "${red}[!] Error de autenticacion o tiempo de espera agotado.${end}\n"
					iwctl station "$ADAPTADOR" disconnect > /dev/null 2>&1
				fi

				printf "${yellow}Presiona una tecla para reintentar...${end}\n"
				read -n 1
				menu_header
				iwctl station "$ADAPTADOR" get-networks
			done
			;;
		2)
			while true; do
				menu_header
				printf "                    MENU MANUAL DE RED                                \n"
				printf "${yellow}================================================================${end}\n"
				printf " 1) Ver Guia Completa de comandos\n"
				printf " 2) Entrar a Iwctl \n"
				printf " 3) Volver al menu de seleccion\n"
				printf " 4) Salir y continuar con el script de instalacion\n"
				printf "${yellow}================================================================${end}\n"

				pregunta
				read manual_opt

				case $manual_opt in
					1)
						menu_header
						printf "${blue}                GUIA COMPLETA DE COMANDOS IWCTL                  ${end}\n"
						printf "${blue}================================================================${end}\n"
						printf "${yellow}1. Comandos de Dispositivo (Hardware)${end}\n"
						printf "   device list                                     - Lista tarjetas\n"
						printf "   device <wlan> set-property Powered on|off      - ON/OFF tarjeta\n"
						printf "   device <wlan> show                              - Detalles\n\n"
						printf "${yellow}2. Escaneo y Estaciones (Conexion)${end}\n"
						printf "   station list                                  - Dispositivos\n"
						printf "   station <wlan> scan                             - Buscar (Obligatorio)\n"
						printf "   station <wlan> get-networks                     - Ver SSIDs\n"
						printf "   station <wlan> connect <SSID>                   - Conectar\n"
						printf "   station <wlan> show                             - Ver IP y Señal\n\n"
						printf "${yellow}3. Gestion de Redes Conocidas${end}\n"
						printf "   known-networks list                             - Listar guardadas\n"
						printf "   known-networks <SSID> forget                    - Borrar guardada\n\n"
						printf "${yellow}4. Modos Especiales${end}\n"
						printf "   ap <wlan> start-profile <nombre>              - Crear Punto Acceso\n"
						printf "   ad-hoc <wlan> start <nombre> <pass>             - Punto a punto\n"
						printf "${blue}================================================================${end}\n"
						volver
						;;
					2)
						printf "${yellow}Entrando en iwctl... Escribe 'exit' para volver.${end}\n"
						iwctl
						;;
					3)
						break
						;;
					4)
						break 2
						;;
					*)
						printf "${red}[!] Opcion no valida.${end}\n"
						sleep $T_ERR
						;;
				esac
			done
			;;
		3)
			break
			;;
		*)
			printf "${red}[!] Elige 1, 2 o 3.${end}\n"
			sleep $T_ERR
			;;
	esac
done

continuar
