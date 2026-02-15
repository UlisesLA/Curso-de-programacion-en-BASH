#!/usr/bin/env bash
# Shebang: ejecuta con Bash encontrado en $PATH (portátil).

set -euo pipefail
# -e: detiene si un comando falla.
# -u: error si se usa una variable no definida.
# -o pipefail: en "a | b | c" falla si cualquiera falla.

IFS=$'\n\t'
# Separador de palabras: solo salto de línea y tab (evita romper por espacios).

VERSION="1.0.0"  # Constante de ejemplo.

main(){
  # 1) Leer desde teclado (sin interpretar backslashes por -r)
  read -r -p "Tu nombre: " nombre

  # 2) Fecha y ruta actual
  hoy="$(date +%F_%H-%M-%S)"   # Ej.: 2025-09-11_16-10-00
  ruta="$(pwd)"                # Directorio actual

  # 3) Crear carpeta/archivo de salida
  mkdir -p salidas             # -p: crea padres si no existen
  archivo="salidas/hola_${hoy}.txt"
  touch "$archivo"             # Crea o actualiza timestamp

  # 4) Escribir datos (printf: control explícito de saltos \n)
  printf "Hola, %s\n" "$nombre" > "$archivo"
  printf "Fecha: %s\nRuta: %s\n" "$hoy" "$ruta" >> "$archivo"

  # 5) Mostrar resultado en pantalla
  echo "Archivo creado: $archivo"
  echo "Contenido:"
  cat "$archivo"

  # 6) Listar carpeta y mostrar código de salida del último comando
  ls -la salidas
  echo "Código de salida de 'ls': $?"   # 0 = ok
}

# Punto de entrada (sin argumentos)
main
