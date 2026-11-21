#!/bin/sh
# =====================================================================
#  programas/copiar.sh: copia los PDFs de los programas de estudio a la
#  app y les saca el texto.
# =====================================================================
#  Lee data/programas/mapa.csv (clave,carrera,archivo) y, por cada PDF de
#  la carpeta que le pases:
#    · lo copia a src/materias/<clave>.pdf   (lo sirve Apache);
#    · saca el texto de su 1.ª hoja (el programa sintético; -raw lo deja
#      en orden) a data/programas/<clave>.txt, que luego lee
#      importador/materias.php para el propósito y los temas.
#
#  PHP no lee PDF y pdftotext viene con MSYS2 UCRT64, no con Docker; por
#  eso esto corre en tu Git Bash / UCRT64, desde la carpeta del proyecto:
#
#      sh importador/programas/copiar.sh "/c/Users/Px/Documents/Escuela/Planes de estudio"
#      docker compose run --rm web php importador/materias.php
#
#  Los PDFs escaneados (imágenes) dan un .txt casi vacío: esa materia
#  queda con su PDF pero sin propósito ni temas (ver investigadas.csv).
#  Se puede repetir: vuelve a copiar y a sacar el texto.
# =====================================================================
set -e

ORIGEN="$1"
if [ -z "$ORIGEN" ] || [ ! -d "$ORIGEN" ]; then
  echo "Uso: sh importador/programas/copiar.sh \"/ruta/a/Planes de estudio\"" >&2
  exit 1
fi
command -v pdftotext >/dev/null || { echo "Falta pdftotext (viene con MSYS2 UCRT64)." >&2; exit 1; }

mkdir -p src/materias data/programas
# tail: salta el encabezado; tr: por si el CSV trae fin de línea de Windows
tail -n +2 data/programas/mapa.csv | tr -d '\r' | while IFS=, read -r clave carrera archivo; do
  if [ ! -f "$ORIGEN/$archivo" ]; then
    echo "  falta: $archivo ($clave)" >&2
    continue
  fi
  cp "$ORIGEN/$archivo" "src/materias/$clave.pdf"
  pdftotext -raw -l 1 -enc UTF-8 "$ORIGEN/$archivo" "data/programas/$clave.txt" 2>/dev/null || : > "data/programas/$clave.txt"
done
echo "PDFs en src/materias: $(ls src/materias/*.pdf | wc -l)"
echo "Textos en data/programas: $(ls data/programas/*.txt | wc -l)"
