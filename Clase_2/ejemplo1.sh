#!/usr/bin/env bash
# si_no.sh
read -p "¿Quieres continuar? (si/no): " resp

if [ "$resp" = "si" ]; then
  echo "Perfecto, continuamos."
elif [ "$resp" = "no" ]; then
  echo "Ok, saliendo."
else
  echo "Escribe 'si' o 'no'."
fi
