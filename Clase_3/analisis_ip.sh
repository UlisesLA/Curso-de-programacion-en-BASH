#!/usr/bin/env bash


set -euo pipefail          # cortar en errores/variables no definidas
IFS=$'\n\t'                # separadores seguros (nueva línea y tab)

# -------- VARIABLES GLOBALES (simples) ------------------------------------
BASE=""                    # Base de red: ej. 192.168.1
START=1                    # Host inicio: 1..254
END=254                    # Host fin:    1..254
REPORTE=""                 # Ruta del archivo de salida
DISPONIBLES=0              # Contador de IPs que responden

PING="ping"                # Comando ping
PING_ARGS=()               # Banderas de ping (según SO)

# -------- VALIDACIONES (solo lo indispensable) ----------------------------
validaciones() {
  # 1) BASE no vacía
  if [ -z "$BASE" ]; then
    echo "Error: la base de red no puede estar vacía (ej. 192.168.1)."
    exit 1
  fi

  # 2) START y END deben ser números (if simple; sin regex/case)
  #    Truco: la comparación -eq falla si no son enteros → lo detectamos con if.
  if ! [ "$START" -eq "$START" ] 2>/dev/null; then
    echo "Error: Host inicio debe ser un número (1-254)."
    exit 1
  fi
  if ! [ "$END" -eq "$END" ] 2>/dev/null; then
    echo "Error: Host fin debe ser un número (1-254)."
    exit 1
  fi

  # 3) Rangos válidos y que END >= START
  if [ "$START" -lt 1 ] || [ "$START" -gt 254 ]; then
    echo "Error: Host inicio fuera de rango (1..254)."
    exit 1
  fi
  if [ "$END" -lt 1 ] || [ "$END" -gt 254 ] || [ "$END" -lt "$START" ]; then
    echo "Error: Host fin fuera de rango (1..254) o menor que inicio."
    exit 1
  fi

  # 4) Verificar que exista el comando ping
  if ! command -v ping >/dev/null 2>&1; then
    echo "Error: 'ping' no está disponible en este entorno."
    exit 1
  fi
}

# -------- ANÁLISIS DE UNA IP (con animación de puntos) --------------------
analisis_ip() {
  # Recibe una IP y:
  # - Muestra "Analizando <IP> ......." con puntos mientras corre ping
  # - Si responde, imprime y guarda:  ip: <IP> - Conexion ok.
  # - Si NO responde, solo muestra [--] en pantalla (no lo guarda)
  local ip="$1"

  # 1) Mensaje inicial de progreso (sin salto de línea)
  printf 'Analizando %s ' "$ip"

  # 2) Ejecutar ping en segundo plano (con banderas correctas para el SO)
  "$PING" "${PING_ARGS[@]}" "$ip" >/dev/null 2>&1 &
  local pid=$!

  # 3) Animación: imprimir puntos mientras el ping sigue ejecutándose
  #    - kill -0 <pid> devuelve 0 si el proceso existe (sigue vivo)
  while kill -0 "$pid" 2>/dev/null; do
    printf '.'
    sleep 0.1
  done

  # 4) Obtener el código de salida del ping sin cortar el script:
  #    - Usamos 'if wait "$pid"; then ...' para capturarlo de forma segura.
  if wait "$pid"; then
    printf ' [OK]\n'
    printf 'ip: %s - Conexion ok.\n' "$ip" >> "$REPORTE"   # guardar en archivo
    printf 'ip: %s - Conexion ok.\n' "$ip"                 # mostrar en pantalla
    DISPONIBLES=$(( DISPONIBLES + 1 ))                     # sumar 1 al total
  else
    printf ' [--]\n'   # sin respuesta (no se escribe en el archivo)
  fi
}

# -------- PROGRAMA PRINCIPAL ---------------------------------------------
main() {
  echo "=== Detector básico de IPs disponibles ==="

  # 1) Entradas del usuario (leer como texto simple)
  read -r -p "Base de red (ej. 192.168.1): " BASE
  read -r -p "Host inicio (1-254): " START
  read -r -p "Host fin    (1-254): " END

  # 2) Validar datos
  validaciones

  # 3) Elegir banderas de ping según el sistema (autodetección simple)
  #    Linux  : -c 1 (un paquete), -W 1 (timeout en segundos)
  #    macOS  : -c 1, -W 1000 (timeout en milisegundos)
  #    Windows (Git Bash/MSYS/Cygwin): -n 1, -w 1000 (ms)
  case "$(uname -s)" in
    Linux*)               PING_ARGS=(-c 1 -W 1) ;;
    Darwin*)              PING_ARGS=(-c 1 -W 1000) ;;
    MINGW*|MSYS*|CYGWIN*) PING_ARGS=(-n 1 -w 1000) ;;
    *)                    PING_ARGS=(-c 1 -W 1) ;;
  esac

  # 4) Preparar carpeta y archivo de reporte
  mkdir -p reports
  REPORTE="reports/ping_report_$(date +%Y%m%d_%H%M%S).txt"
  : > "$REPORTE"   # crear/limpiar el archivo (quedará solo con IPs OK + línea final)

  # 5) Mensaje de inicio
  printf 'Escaneando %s.%s .. %s.%s (solo se listarán las IPs con respuesta)\n' \
         "$BASE" "$START" "$BASE" "$END"

  # 6) Recorrer el rango de hosts con un for numérico estilo C
  for (( host=START; host<=END; host++ )); do
    analisis_ip "$BASE.$host"
  done

  # 7) Al final: mostrar y guardar el total de IPs disponibles
  printf 'IPs disponibles en tu red: %d\n' "$DISPONIBLES"
  printf 'IPs disponibles en tu red: %d\n' "$DISPONIBLES" >> "$REPORTE"

  echo "Reporte guardado en: $REPORTE"
}

# Ejecutar el programa principal
main
