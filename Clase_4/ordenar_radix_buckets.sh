#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Uso: ./ordenar_radix_buckets.sh [entrada] [salida]
# Disenado para volumen grande (ej. numeros_500k.txt)
# Requiere un directorio temporal para buckets por pasada.

IN="${1:-numeros_500k.txt}"
OUT="${2:-ordenado_radix.txt}"

# Cantidad de digitos (500000 cabe en 6 digitos si se rellena con ceros)
DIGITS=6

printf 'Radix buckets | entrada: %s | salida: %s | digitos: %d\n' "$IN" "$OUT" "$DIGITS"

start=$(date +%s)

# Crear directorio temporal unico para esta sesion
TMP="radix_tmp_$$"
mkdir -p "$TMP"

# Archivo de trabajo actual (inicialmente la entrada original)
CUR="$TMP/current.txt"
cp "$IN" "$CUR"

# Pasadas LSD (Least Significant Digit): pos = ultimo digito -> primer digito
# En cada pasada:
#   1) crear 10 buckets vacios 0..9
#   2) leer CUR linea por linea
#   3) para cada numero, zero-pad a %06d, tomar digito en posicion pos
#   4) escribir el numero original en el bucket correspondiente
#   5) concatenar buckets 0..9 en NEXT y reemplazar CUR
for (( pos=DIGITS-1; pos>=0; pos-- )); do
  # limpiar/crear buckets
  for d in 0 1 2 3 4 5 6 7 8 9; do
    : > "$TMP/b$d.txt"
  done

  # distribuir numeros a buckets segun el digito en posicion pos
  # leemos linea por linea para no cargar todo en RAM
  while IFS= read -r n; do
    # asegurar formato de 6 digitos con ceros a la izquierda (para extraer digitos)
    zp=$(printf "%06d" "$n")
    # extraer el caracter digito en posicion pos (0-index)
    digit=${zp:$pos:1}
    # anexar el numero original al bucket digit
    printf '%s\n' "$n" >> "$TMP/b$digit.txt"
  done < "$CUR"

  # concatenar buckets en orden 0..9 en el siguiente archivo de trabajo
  NEXT="$TMP/next.txt"
  : > "$NEXT"
  for d in 0 1 2 3 4 5 6 7 8 9; do
    # anexar el contenido del bucket d si no esta vacio
    # cat falla si el archivo no existe, pero aqui siempre existe (lo creamos vacio)
    cat "$TMP/b$d.txt" >> "$NEXT"
  done

  # preparar siguiente pasada: NEXT pasa a ser CUR
  mv "$NEXT" "$CUR"

  # opcional: limpiar buckets para ahorrar espacio entre pasadas
  for d in 0 1 2 3 4 5 6 7 8 9; do
    : > "$TMP/b$d.txt"
  done
done

# Al finalizar, CUR esta ordenado
mv "$CUR" "$OUT"

# Limpieza del directorio temporal
rm -rf "$TMP"

end=$(date +%s)
printf 'Tiempo (s): %d\n' "$(( end - start ))"
