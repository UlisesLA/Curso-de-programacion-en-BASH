#!/usr/bin/env bash
# gestor_notas_basico.sh
# ----------------------------------------------------------
# OBJETIVO:
#   Demostrar uso de variables, comillas, aritmética, if/elif/else,
#   pruebas de archivos/directorios con [ ], case y comandos básicos.
# ----------------------------------------------------------

# ---------------------- PASO 1: VARIABLES -----------------
# Pedimos el nombre de la carpeta del proyecto y lo guardamos en una variable.
# Nota: usamos comillas al expandir variables para conservar espacios.
read -p "Nombre del proyecto (carpeta): " PROYECTO

# Validación simple: que no esté vacío (prueba de cadena -z).
if [ -z "$PROYECTO" ]; then
  echo "El nombre del proyecto no puede estar vacío."
  exit 1
fi

# ----------------- PASO 2: CARPETA DE PROYECTO -----------
# Si la carpeta no existe (-d verifica directorios), la creamos.
if [ ! -d "$PROYECTO" ]; then
  echo "Creando carpeta '$PROYECTO'..."
  mkdir -p "$PROYECTO"  # -p evita error si existen rutas intermedias
else
  echo "La carpeta '$PROYECTO' ya existe."
fi

# Mostramos la ruta actual (pwd) y listamos el contenido (ls).
echo "Ruta actual:"
pwd
echo "Contenido de '$PROYECTO' (puede estar vacío):"
ls -la "$PROYECTO"

# ---------------- PASO 3: ARCHIVO DE NOTAS ----------------
# Preparamos una variable con la ruta del archivo de notas y lo creamos con touch.
NOTAS="$PROYECTO/notas.txt"
if touch "$NOTAS"; then
  echo "Usaremos el archivo de notas: $NOTAS"
else
  echo "No se pudo crear $NOTAS (revisa permisos)."
  exit 1
fi

# ---------------- PASO 4: ENTRADAS Y ARITMÉTICA -----------
# Pedimos algunos datos y hacemos una suma con $(( ... )).
read -p "Tu nombre: " NOMBRE
read -p "¿Cuántas tareas completas tienes? " COMPLETAS
read -p "¿Cuántas tareas pendientes tienes? " PENDIENTES

# Aritmética básica (enteros).
TOTAL=$(( COMPLETAS + PENDIENTES ))

# Decisión con if/elif/else (comparaciones numéricas con -eq, etc.).
if [ "$TOTAL" -eq 0 ]; then
  ESTADO="No hay tareas registradas aún."
elif [ "$PENDIENTES" -eq 0 ]; then
  ESTADO="¡Excelente! No tienes pendientes."
else
  ESTADO="Tienes $PENDIENTES pendientes de un total de $TOTAL."
fi

# --------------- PASO 5: MENÚ CON 'case' ------------------
# Ofrecemos opciones sencillas para trabajar con el archivo de notas.
echo
echo "¿Qué deseas hacer?"
echo "  1) Guardar un resumen en $NOTAS"
echo "  2) Ver el contenido de $NOTAS"
echo "  3) Crear y mostrar 'hola.txt' dentro del proyecto"
echo "  4) Salir"
read -p "Opción: " OPCION

case "$OPCION" in
  1)
    # Guardamos una entrada con fecha y datos.
    FECHA=$(date +%F" "%T)  # Capturamos salida de 'date' (comillas dobles permiten espacios)
    echo "[$FECHA] Usuario: $NOMBRE" >> "$NOTAS"
    echo "[$FECHA] Completas: $COMPLETAS, Pendientes: $PENDIENTES, Total: $TOTAL" >> "$NOTAS"
    echo "[$FECHA] Estado: $ESTADO" >> "$NOTAS"
    echo "Resumen guardado en '$NOTAS'."
    ;;
  2)
    # Antes de leer, verificamos que exista y sea legible (-f y -r).
    if [ -f "$NOTAS" ] && [ -r "$NOTAS" ]; then
      echo "---- Contenido de $NOTAS ----"
      cat "$NOTAS"
    else
      echo "El archivo $NOTAS no existe o no es legible."
    fi
    ;;
  3)
    # Creamos otro archivo con touch y lo mostramos con cat.
    ARCHIVO="$PROYECTO/hola.txt"
    touch "$ARCHIVO"
    echo "Hola $NOMBRE, este es tu proyecto '$PROYECTO'." > "$ARCHIVO"
    echo "---- Contenido de $ARCHIVO ----"
    cat "$ARCHIVO"
    ;;
  4)
    echo "¡Listo! Hasta luego."
    ;;
  *)
    echo "Opción no válida."
    ;;
esac
