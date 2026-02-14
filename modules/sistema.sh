#!/bin/bash

# 2. DISTRIBUCION DEL TECLADO
menu_header
print_title "PRE-CONFIGURANDO SISTEMA"

printf "${yellow}[*] Configurando teclado...${end}\n"
loadkeys es
printf "${green}[+] Teclado configurado en espanol.${end}\n"
pausa

# 3. SERVICIO NTP
menu_header
print_title "PRE-CONFIGURANDO SISTEMA"

printf "${yellow}[*] Sincronizando la hora del sistema (NTP)...${end}\n"
timedatectl set-ntp true
sleep 2
printf "${green}[+] Hora del sistema sincronizada.${end}\n\n"
printf "${blue}Estado actual del tiempo:${end}\n"
timedatectl status | grep -E "Local time|Universal time|RTC time|System clock synchronized|NTP service"
printf "\n"
pausa

# 4. VERIFICAR EL MODO DE ARRANQUE
menu_header
print_title "PRE-CONFIGURANDO SISTEMA"

printf "\n${yellow}[*] Verificando modo de arranque...${end}\n"
if [ -d "/sys/firmware/efi" ]; then
	printf "${green}[+] Sistema en modo UEFI.${end}\n"
else
	printf "${red}[!] Estas en modo BIOS/Legacy.${end}\n"
	while true; do
		printf "¿Deseas continuar de todas formas? (s/n): "
		read cont_bios
		case $cont_bios in
			[Ss]) break ;;
			[Nn])
				printf "${red}Abortando por eleccion del usuario.${end}\n"
				exit 1
				;;
			*)
				printf "\e[1A\e[K${red}[!] Opcion no valida.${end}"; sleep 1; printf "\r\e[K"
				;;
		esac
	done
fi
pausa
