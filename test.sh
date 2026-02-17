#!/bin/bash

# --- ORGANIZACION DE ICONOS ---
# Formato: "Nombre representativo" "Codigo Unicode"
iconos=(
	"PROMPT_ENTRADA_1" "\u276f"
	"PROMPT_ENTRADA_2" "\uf0a1"
	"SIGUIENTE_DOBLE"  "\u00bb"
	"SIGUIENTE_PLAY"   "\u25ba"
	"FLECHA_DERECHA"   "\u2192"
	"OK_CHECK_NERD"    "\uf00c"
	"OK_RAIZ_SQUARE"   "\u221a"
	"ERROR_X_NERD"     "\uf00d"
	"ERROR_X_BOLD"     "\u2718"
	"ERROR_X_MATH"     "\u00d7"
	"AVISO_TRIANGULO"  "\u26a0"
	"AVISO_NERD_INFO"  "\uf06a"
	"INFO_LETRA_I"     "\u2139"
	"ENTER_RETORNO"    "\u21b5"
	"PUNTO_LISTA"      "\u2022"
	"ASTERISCO"        "\u002a"
	"ATRÁS_BACK"       "\u25c4"
)

clear
printf "=== TEST DE ICONOS PARA TU TTY ===\n"
printf "Si ves un cuadradito o espacio vacio, ese icono NO sirve.\n"
printf "Presiona [ENTER] para ver el siguiente...\n\n"

# El bucle recorre la lista de dos en dos
for ((i=0; i<${#iconos[@]}; i+=2)); do
	nombre="${iconos[i]}"
	codigo="${iconos[i+1]}"
	
	# Imprime el nombre y el icono procesado
	printf "%-20s : %b  (Codigo: %s)" "$nombre" "$codigo" "$codigo"
	read -r
done

printf "\n--- Test finalizado ---\n"
