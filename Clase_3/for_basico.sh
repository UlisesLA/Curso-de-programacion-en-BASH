#!/usr/bin/env bash

#forma uno de colocar for
for i in 1 2 3
do
  echo "$i"
done

#forma 2 de colocar el for
for i in 1 2 3; do echo "$i"; done


#(lista de palabras)
for nombre in Ana Beto Carla; do
  echo "$nombre"
done


#for (rango numérico estilo C)

for (( i=1; i<=5; i++ )); do
  echo "$i"
done
