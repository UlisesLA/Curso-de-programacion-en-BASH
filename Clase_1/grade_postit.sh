#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Uso: ./grade_postit.sh ./alumnos/ulises_postit.sh
SCRIPT="${1:-}"
if [[ -z "$SCRIPT" || ! -f "$SCRIPT" ]]; then
  echo "Uso: $0 /ruta/al/nombre_postit.sh"; exit 2
fi

base="$(basename -- "$SCRIPT")"
if [[ ! "$base" =~ _postit\.sh$ ]]; then
  echo "Nombre inválido: '$base' (debe terminar en _postit.sh)"; exit 3
fi
alumno="${base%_postit.sh}"

# Preparar entorno aislado
TMPDIR="$(mktemp -d)"
cp "$SCRIPT" "$TMPDIR/alumno.sh"
chmod +x "$TMPDIR/alumno.sh"
cd "$TMPDIR"

score=0
report=()

# A. Modo seguro y entorno (3 pts)
head -n1 alumno.sh | grep -Eiq '^#!.*bash' && ((score++)) && report+=("[OK] Shebang bash") || report+=("[--] Falta shebang bash")
grep -Eq 'set +-e' alumno.sh && grep -Eq 'set +-u' alumno.sh && grep -Eq 'pipefail' alumno.sh && ((score++)) && report+=("[OK] set -euo pipefail") || report+=("[--] Falta set -euo pipefail")
grep -Eq "IFS=\$'\\n\\t'" alumno.sh && ((score++)) && report+=("[OK] IFS seguro") || report+=("[--] Falta IFS seguro")

# B. Entradas y variables (3 pts)
grep -Eq '^[[:space:]]*VERSION=' alumno.sh && ((score++)) && report+=("[OK] VERSION definida") || report+=("[--] Falta VERSION")
grep -Eq 'read +-r' alumno.sh && ((score++)) && report+=("[OK] read -r usado") || report+=("[--] Falta read -r")
grep -Eq '\bdate\b' alumno.sh && ((score++)) && report+=("[OK] date usado") || report+=("[--] Falta date")

# Ejecutar (sin argumentos) con entradas simuladas
OUT="$(printf 'titulo_demo\nmensaje_demo\n' | ./alumno.sh 2>&1 || true)"
EXIT_RUN=$?

# C. Fechas/archivos/comandos (3 pts)
dir_created=""
for d in notas salidas; do [[ -d "$d" ]] && { dir_created="$d"; break; }; done
[[ -n "$dir_created" ]] && ((score++)) && report+=("[OK] Carpeta creada: $dir_created") || report+=("[--] No se creó carpeta (notas/ o salidas/)")

archivo=""
[[ -n "$dir_created" ]] && archivo="$(ls -1t "$dir_created"/*.txt 2>/dev/null | head -n1 || true)"
if [[ -n "$archivo" && -f "$archivo" ]]; then
  need=0
  grep -Eq 'T[ÍI]TULO:|Hola, ' "$archivo" && ((need++))
  grep -Eq 'MENSAJE:|Fecha:' "$archivo" && ((need++))
  grep -Eq 'FECHA:|Ruta:' "$archivo" && ((need++))
  (( need >= 2 )) && ((score++)) && report+=("[OK] Archivo con contenido") || report+=("[--] Contenido incompleto")
else
  report+=("[--] No se encontró .txt en la carpeta")
fi

used_pwd=false; used_ls=false
grep -Eq '\bpwd\b' alumno.sh && used_pwd=true
grep -Eq '\bls\b'  alumno.sh && used_ls=true
ok_ls_code=false; echo "$OUT" | grep -q 'Código de salida de .*ls.*: 0' && ok_ls_code=true
if $used_pwd && $used_ls; then
  $ok_ls_code && ((score++)) && report+=("[OK] pwd/ls y código ls=0") || report+=("[--] pwd/ls usados pero código != 0")
else
  report+=("[--] Falta uso de pwd o ls")
fi

# D. Salida general (1 pt)
[[ "$EXIT_RUN" -eq 0 ]] && ((score++)) && report+=("[OK] Script ejecutó (exit 0)") || report+=("[--] Script terminó con error (exit $EXIT_RUN)")

echo "============ RESULTADOS ($alumno) ============"
printf '%s\n' "${report[@]}"
echo "----------------------------------------------"
echo "PUNTAJE: $score/10"
echo "=============================================="
