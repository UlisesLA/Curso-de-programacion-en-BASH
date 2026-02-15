#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Uso: ./ordenar_seleccion.sh [entrada] [salida]
# Sugerencia: usar numeros_10k.txt

IN="${1:-numeros_10k.txt}"
OUT="${2:-ordenado_seleccion.txt}"

mapfile -t A < "$IN"
N=${#A[@]}

printf 'Seleccion | elementos: %d | entrada: %s | salida: %s\n' "$N" "$IN" "$OUT"

start=$(date +%s)

# Idea: para cada posicion i, encontrar el minimo en [i..N-1] y ponerlo en i
for (( i=0; i<N-1; i++ )); do
  min_idx=$i                      # asumimos que A[i] es el minimo
  for (( j=i+1; j<N; j++ )); do
    # si encontramos un valor menor, actualizamos min_idx
    if (( A[j] < A[min_idx] )); then
      min_idx=$j
    fi
  done
  # si el minimo no esta en i, intercambiamos
  if (( min_idx != i )); then
    tmp=${A[i]}
    A[i]=${A[min_idx]}
    A[min_idx]=$tmp
  fi
done

printf "%s\n" "${A[@]}" > "$OUT"

end=$(date +%s)
printf 'Tiempo (s): %d\n' "$(( end - start ))"
