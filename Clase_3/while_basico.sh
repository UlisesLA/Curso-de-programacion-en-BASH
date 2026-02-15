#!/usr/bin/env bash

# while (condición numérica)
contador=1
while (( contador<=3 )); do
  echo "$contador"
  (( contador++ ))
done

# while leyendo líneas de un archivo
while read -r linea; do
  echo ">> $linea"
done < archivo.txt
