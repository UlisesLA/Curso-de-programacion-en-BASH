#!/usr/bin/env bash
# while_contar_hasta.sh
# Contamos desde 1 hasta N con while y aritmética (( )).

# Pedimos un número. Por ahora asumimos que escribes un ENTERO.
read -r -p "¿Contar hasta (entero)? " N

contador=1                 # iniciamos en 1
while (( contador<=N )); do
  echo "$contador"
  (( contador++ ))         # sumamos 1 en cada vuelta
done

echo "Fin de la cuenta."
