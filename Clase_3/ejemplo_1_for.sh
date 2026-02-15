#!/usr/bin/env bash
# for_basico.sh
# Demostración simple de for: lista y rango numérico.

# 1) Recorremos una LISTA de palabras (espacios entre ellas)
for nombre in Ana Beto Carla; do
  echo "Hola, $nombre"
done

echo "----"

# 2) Recorremos un RANGO numérico (1 a 5) con estilo C
for (( i=1; i<=5; i++ )); do
  echo "Número: $i"
done
