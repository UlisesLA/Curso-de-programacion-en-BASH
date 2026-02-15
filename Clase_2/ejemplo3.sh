#!/usr/bin/env bash
# menu_basico.sh
echo "Menú:"
echo "  1) Mostrar ruta actual (pwd)"
echo "  2) Crear carpeta 'pruebas' y listar"
echo "  3) Crear 'hola.txt' y mostrarlo"
echo "  4) Salir"
read -p "Elige opción: " op

case "$op" in
  1)
    pwd
    ;;
  2)
    mkdir -p pruebas
    ls -la pruebas
    ;;
  3)
    touch hola.txt
    echo "Hola!" > hola.txt
    cat hola.txt
    ;;
  4)
    echo "Adiós";;
  *)
    echo "Opción no válida";;
esac
