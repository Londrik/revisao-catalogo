#!/usr/bin/env bash
# Uso: ./configurar-url.sh https://script.google.com/macros/s/XXXX/exec
# Troca o marcador no index.html pela URL do Apps Script e commita. Não faz push.
set -euo pipefail
cd "$(dirname "$0")"
URL="${1:-}"
[[ "$URL" =~ ^https://script\.google\.com/macros/s/[A-Za-z0-9_-]+/exec$ ]] || { echo "URL inválida. Deve terminar em /exec e começar com https://script.google.com/macros/s/"; exit 1; }
grep -q "COLE_AQUI_A_URL_DO_APPS_SCRIPT" index.html || { echo "Marcador não encontrado (já configurado?)."; exit 1; }
sed -i "s#COLE_AQUI_A_URL_DO_APPS_SCRIPT#${URL}#" index.html
git add index.html && git -c user.name="londrik" -c user.email="noreply@localhost" commit -q -m "chore: configura URL do Apps Script"
echo "OK. Agora rode ./publicar.sh"
