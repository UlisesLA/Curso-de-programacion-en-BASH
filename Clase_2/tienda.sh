#!/usr/bin/env bash
# ------------------------------------------------------------
# MINI TIENDA DE DULCES - Evaluación Rápida
# Propósito:
#   - Practicar: variables, comillas, read, aritmética $(( )),
#     if/elif/else, pruebas con [ ], case y comandos básicos:
#     pwd, ls, mkdir, touch, cat, date.
#   - Generar un "ticket" (archivo de texto) con el resumen
#     de una compra sencilla.
# Reglas:
#   - Descuento del 10% si la cantidad comprada es >= 5.
#   - Solo usar lo visto en clase (nada de bucles/regex).
# ------------------------------------------------------------

# --- Seguridad básica en Bash (lo pediste tú, y te lo explico sencillo) ---
set -euo pipefail
# set -e  : si algún comando falla, el script termina (evita continuar con errores).
# set -u  : si usas una variable NO definida, el script termina (evita "sorpresas").
# set -o pipefail : si una parte de un "pipe" (cmd1 | cmd2) falla, cuenta como fallo.
IFS=$'\n\t'
# IFS: separadores internos. Aquí solo NUEVA LÍNEA y TAB.
#      ¿Por qué? Evitamos que un espacio en un nombre (ej. "Mis Notas")
#      rompa las cosas. Siempre cita variables: "$variable".

# -------------------- PASO 0: BIENVENIDA Y CONTEXTO ------------------------
echo "=== Mini Tienda de Dulces ==="
echo "Ubicación actual (pwd):"
pwd           # Comando básico: muestra la ruta actual
echo

# -------------------- PASO 1: MENÚ DE PRODUCTOS ---------------------------
# Mostramos el menú con precios fijos (variables aparecerán luego).
echo "Elige un producto del menú:"
echo "  1) Gomitas     ($12 c/u)"
echo "  2) Chocolate   ($15 c/u)"
echo "  3) Paleta      ($8  c/u)"
echo "  4) Salir"

# 'read' guarda lo que escribe el usuario en una variable.
# -r: toma el texto tal cual (sin tratar '\' como escape).
read -r -p "Opción: " OPCION

# -------------------- PASO 2: DECISIÓN CON 'case' ------------------------
# Según la opción elegida, asignamos VARIABLES: PRODUCTO y PRECIO.
case "$OPCION" in
  1)
    PRODUCTO="Gomitas"    # Texto: una cadena
    PRECIO=12             # Entero: lo usaremos en aritmética
    ;;
  2)
    PRODUCTO="Chocolate"
    PRECIO=15
    ;;
  3)
    PRODUCTO="Paleta"
    PRECIO=8
    ;;
  4)
    echo "Salida solicitada por el usuario. ¡Hasta luego!"
    exit 0
    ;;
  *)
    # Si la opción no es 1-4, avisamos y terminamos.
    echo "Opción no válida. Ejecuta de nuevo y elige 1-4."
    exit 1
    ;;
esac

# Confirmamos la elección al usuario:
echo
echo "Elegiste: \"$PRODUCTO\" con precio unitario: $PRECIO"
echo

# -------------------- PASO 3: PEDIR CANTIDAD ------------------------------
# Pedimos una cantidad entre 1 y 9. Lo validaremos con 'case' simple.
read -r -p "¿Cantidad (1-9)?: " CANT

# Validación básica: aceptamos únicamente dígitos del 1 al 9.
# (sin regex; 'case' con alternativas separadas por '|')
case "$CANT" in
  1|2|3|4|5|6|7|8|9)
    # Cantidad válida; no hacemos nada aquí.
    ;;
  *)
    echo "Cantidad inválida. Debe ser un número del 1 al 9."
    exit 1
    ;;
esac

# -------------------- PASO 4: ARITMÉTICA ---------------------------------
# Calculamos SUBTOTAL, posible DESCUENTO y TOTAL.
# $(( ... )) realiza operaciones con enteros.
SUBTOTAL=$(( PRECIO * CANT ))

# Si la cantidad es 5 o más, descuento de 10% (entero).
if [ "$CANT" -ge 5 ]; then
  DESCUENTO=$(( SUBTOTAL / 10 ))   # 10% es la décima parte
else
  DESCUENTO=0
fi

TOTAL=$(( SUBTOTAL - DESCUENTO ))

# Mostramos un pequeño resumen por pantalla (informativo).
echo
echo "Resumen:"
echo "  Producto : $PRODUCTO"
echo "  Cantidad : $CANT"
echo "  Subtotal : $SUBTOTAL"
echo "  Descuento: $DESCUENTO"
echo "  TOTAL    : $TOTAL"

# -------------------- PASO 5: PREPARAR CARPETA DE TICKETS -----------------
# Creamos una carpeta "tickets" para guardar los resultados.
# -p: crea la carpeta si no existe (y no falla si ya existe).
mkdir -p tickets

# Construimos el nombre del archivo de ticket con fecha y hora.
# $(date ...) captura la salida del comando date.
TICKET="tickets/ticket_$(date +%Y%m%d_%H%M%S).txt"

# Creamos el archivo vacío para asegurar que existe (y probar permisos).
touch "$TICKET"

# -------------------- PASO 6: ESCRIBIR EL TICKET --------------------------
# '>>' agrega líneas al final del archivo.
echo "=== Mini Tienda de Dulces ==="            >> "$TICKET"
echo "Fecha: $(date)"                           >> "$TICKET"
echo "Producto: $PRODUCTO"                      >> "$TICKET"
echo "Precio unitario: $PRECIO"                 >> "$TICKET"
echo "Cantidad: $CANT"                          >> "$TICKET"
echo "Subtotal: $SUBTOTAL"                      >> "$TICKET"
echo "Descuento (10% si Cant>=5): $DESCUENTO"   >> "$TICKET"
echo "TOTAL A PAGAR: $TOTAL"                    >> "$TICKET"

# -------------------- PASO 7: MOSTRAR RESULTADOS --------------------------
echo
echo "Compra registrada. Ticket guardado en:"
echo "  $TICKET"
echo
echo "Contenido del ticket (cat):"
cat "$TICKET"   # 'cat' imprime el contenido del archivo

# También listamos la carpeta para que veas que se creó:
echo
echo "Archivos en carpeta 'tickets' (ls -la):"
ls -la tickets

# Fin del script.
# ------------------------------------------------------------
