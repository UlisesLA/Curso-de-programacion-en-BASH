#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Uso: ./ordenar_insercion.sh [entrada] [salida]
# Sugerencia: usar numeros_10k.txt

IN="${1:-numeros_10k.txt}"
OUT="${2:-ordenado_insercion.txt}"

mapfile -t A < "$IN"
N=${#A[@]}

printf 'Insercion | elementos: %d | entrada: %s | salida: %s\n' "$N" "$IN" "$OUT"

start=$(date +%s)

# Idea: tomamos A[i] y lo insertamos en la parte izquierda ya ordenada [0..i-1]
for (( i=1; i<N; i++ )); do
  key=${A[i]}            # elemento a insertar
  j=$(( i - 1 ))         # empezamos a comparar desde el indice anterior

  # mientras haya elementos mayores que key, los corremos a la derecha
  while (( j>=0 && A[j] > key )); do
    A[j+1]=${A[j]}       # correr A[j] a la derecha
    j=$(( j - 1 ))       # avanzar a la izquierda
  done
  # colocar key en su posicion correcta
  A[j+1]=$key
done

printf "%s\n" "${A[@]}" > "$OUT"

end=$(date +%s)
printf 'Tiempo (s): %d\n' "$(( end - start ))"
