#!/usr/bin/env bash
# Shebang: ejecuta con Bash del $PATH.

set -euo pipefail
# -e: detener al primer error
# -u: error si variable no definida
# pipefail: falla el pipeline si falla cualquiera

IFS=$'\n\t'  # separador seguro (no rompe por espacios)
VERSION="1.0.0"  # constante de ejemplo

titulo(){
  printf "=== Post-it digital v%s ===\n" "$VERSION"
}

main(){
  titulo

  # 1) Pedir datos
  read -r -p "Título (sin espacios): " titulo_nota
  read -r -p "Mensaje (una línea): " mensaje

  # 2) Fecha y ruta actual
  fecha="$(date +%F_%H-%M-%S)"  # ej: 2025-09-11_16-45-00
  ruta="$(pwd)"                 # directorio actual

  # 3) Crear carpeta y archivo
  mkdir -p notas
  archivo="notas/${fecha}_${titulo_nota}.txt"
  touch "$archivo"

  # 4) Escribir contenido
  printf "TÍTULO: %s\n" "$titulo_nota" > "$archivo"
  printf "MENSAJE: %s\n" "$mensaje"    >> "$archivo"
  printf "FECHA: %s\nRUTA: %s\n" "$fecha" "$ruta" >> "$archivo"

  # 5) Mostrar por pantalla y listar carpeta
  echo "Post-it creado: $archivo"
  echo "Contenido:"
  cat "$archivo"

  ls -la notas
  echo "Código de salida de 'ls': $?"   # 0 = OK
}

main
