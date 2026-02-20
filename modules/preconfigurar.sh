#!/bin/bash

# 2. DISTRIBUCION DEL TECLADO
menu_header
print_title "PRE-CONFIGURAR"

printf "${ico_star} ${greend}Configurando el teclado en español...${end}\n"
loadkeys es
printf "${ico_ok} ${greenl}Configurado el teclado en español correctamente.${end}\n"
print_continue

# 3. SERVICIO NTP
menu_header
print_title "PRE-CONFIGURAR"

printf "${ico_star} ${greend}Sincronizando la hora del sistema...${end}\n"
timedatectl set-ntp true
sleep $T_INFO
printf "${ico_ok} ${greenl}Sincronizada la hora del sistema correctamente.${end}\n\n"
printf "${gray}Estado actual del tiempo:${end}\n"
timedatectl status | grep -E "Local time|Universal time|RTC time|System clock synchronized|NTP service"
printf "\n"
print_continue

# 4. VERIFICAR EL MODO DE ARRANQUE
menu_header
print_title "PRE-CONFIGURAR"

printf "${ico_star} ${greend}Verificando el modo de arranque...${end}\n"
if [ -d "/sys/firmware/efi" ]; then
	printf "${ico_ok} ${greenl}El modo de arranque es UEFI.${end}\n"
else
	printf "${ico_warn} ${redd}El modo de arranque es BIOS/Legacy.${end}\n"
	if ! print_confirm "Deseas continuar de todas formas?"; then
		printf "${ico_error} ${redl}Instalacion de Arch Linux cancelada. Saliendo del instalador...${end}\n"
		exit 1
	fi
fi
print_continue
