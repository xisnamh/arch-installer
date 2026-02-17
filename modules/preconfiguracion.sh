#!/bin/bash

# 2. DISTRIBUCION DEL TECLADO
menu_header
print_title "PRE-CONFIGURANDO EL SISTEMA"

printf "${yellow}[${ico_star}] Configurando teclado...${end}\n"
loadkeys es
printf "${green}[${ico_ok}] Teclado configurado en español.${end}\n"
print_continue

# 3. SERVICIO NTP
menu_header
print_title "PRE-CONFIGURANDO EL SISTEMA"

printf "${yellow}[${ico_star}] Sincronizando la hora del sistema (NTP)...${end}\n"
timedatectl set-ntp true
sleep $T_INFO
printf "${green}[${ico_ok}] Hora del sistema sincronizada.${end}\n\n"
printf "${blue}Estado actual del tiempo:${end}\n"
timedatectl status | grep -E "Local time|Universal time|RTC time|System clock synchronized|NTP service"
printf "\n"
print_continue

# 4. VERIFICAR EL MODO DE ARRANQUE
menu_header
print_title "PRE-CONFIGURANDO EL SISTEMA"

printf "${yellow}[${ico_star}] Verificando modo de arranque...${end}\n"
if [ -d "/sys/firmware/efi" ]; then
	printf "${green}[${ico_ok}] Sistema en modo UEFI.${end}\n"
else
	printf "${red}[${ico_warn}] Estas en modo BIOS/Legacy.${end}\n"
	if ! print_confirm "Deseas continuar de todas formas?"; then
		printf "${red}Abortando por eleccion del usuario.${end}\n"
		exit 1
	fi
fi
print_continue
