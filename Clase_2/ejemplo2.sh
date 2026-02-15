#!/usr/bin/env bash
# carpeta_archivo.sh
echo "Ruta actual:"
pwd

read -p "Nombre de carpeta: " dir

# Si no existe la carpeta, crearla
if [ ! -d "$dir" ]; then
  echo "Creando carpeta '$dir'..."
  mkdir "$dir"
else
  echo "La carpeta '$dir' ya existe."
fi

echo "Contenido de '$dir' (puede estar vacío):"
ls -la "$dir"

# Crear un archivo y mostrarlo
archivo="$dir/nota.txt"
touch "$archivo"
echo "Hola desde Bash" > "$archivo"
echo "Contenido de $archivo:"
cat "$archivo"
