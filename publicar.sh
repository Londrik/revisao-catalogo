#!/usr/bin/env bash
# Cria o repositório PÚBLICO no GitHub, envia a página e liga o GitHub Pages. Você roda; o Claude não faz push.
set -euo pipefail
cd "$(dirname "$0")"
REPO="${1:-revisao-catalogo}"
grep -q "COLE_AQUI_A_URL_DO_APPS_SCRIPT" index.html && { echo "Antes rode ./configurar-url.sh <URL do Apps Script>."; exit 1; }
CONTA=$(gh api user -q .login)
echo "Conta do GitHub: $CONTA"
echo "Vai criar o repositório PÚBLICO $CONTA/$REPO com fotos e preços do catálogo."
[[ "${2:-}" == "sim" ]] || { echo "Confira a conta acima. Se estiver certa, rode: ./publicar.sh $REPO sim"; exit 1; }
gh repo create "$REPO" --public --description "Revisão do catálogo (fotos, descrição, preço)"
git remote add origin "https://github.com/$CONTA/$REPO.git" 2>/dev/null || git remote set-url origin "https://github.com/$CONTA/$REPO.git"
git push -u origin feat/revisao-catalogo:main
gh api -X POST "repos/$CONTA/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null
echo "Pronto. Em 1 a 2 minutos o link fica em: https://$CONTA.github.io/$REPO/"
