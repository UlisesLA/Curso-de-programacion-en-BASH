#!/usr/bin/env bash
# Ordenamiento por Burbuja en Bash (demo)
# Uso: ./ordenar_burbuja.sh [entrada] [salida]
# Recomendado: usar numeros_10k.txt (10,000) para no tardar horas.

set -euo pipefail
IFS=$'\n\t'

IN="${1:-numeros_10k.txt}"      # por defecto, usa el chico
OUT="${2:-ordenado_burbuja.txt}"

# Leer archivo en un arreglo (una línea = un número)
mapfile -t A < "$IN"
N=${#A[@]}

echo "Burbuja -> elementos: $N | entrada: $IN | salida: $OUT"

start=$(date +%s)

# Burbuja con optimización de 'swapped'
for (( i=0; i<N-1; i++ )); do
  swapped=0
  for (( j=0; j<N-i-1; j++ )); do
    if (( A[j] > A[j+1] )); then
      tmp=${A[j]}
      A[j]=${A[j+1]}
      A[j+1]=$tmp
      swapped=1
    fi
  done
  (( swapped == 0 )) && break
done

# Volcar a archivo
printf "%s\n" "${A[@]}" > "$OUT"

end=$(date +%s)
echo "Tiempo (s): $(( end - start ))"

