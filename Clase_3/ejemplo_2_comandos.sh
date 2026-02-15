#!/usr/bin/env bash
# for_archivos.sh
# Creamos archivos con for y usamos comandos básicos.

# Creamos la carpeta de trabajo (si ya existe, no pasa nada)
mkdir -p lotes

# 1) Crear 3 archivos con contenido usando un for numérico
for (( i=1; i<=3; i++ )); do
  archivo="lotes/nota_$i.txt"   # variable con ruta
  echo "Este es el archivo $i" > "$archivo"
done

# 2) Listar lo que hay en la carpeta (ls)
echo "Contenido de la carpeta 'lotes':"
ls -la lotes

echo "----"

# 3) Recorrer los archivos .txt y mostrarlos (cat)
#    OJO: usamos el patrón lotes/*.txt (con espacios correctos)
for f in lotes/*.txt; do
  echo "=== $f ==="
  cat "$f"
  echo
done

