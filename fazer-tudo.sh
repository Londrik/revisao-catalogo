#!/usr/bin/env bash
# Faz tudo que dá com poucas autorizações suas: liga o código à planilha, publica o app, configura a página e sobe ao GitHub Pages.
# Rode com:  ! ~/emporio-orquestra/revisao-site/fazer-tudo.sh
set -euo pipefail
cd "$(dirname "$0")"
SHEET_ID="174N08L1l78FeZ5zTh9RnempWkPCd61QZ2bhMkWJMt2E"
CLASP="npx --yes @google/clasp@2.4.2"
P=apps-script-proj
rm -rf "$P"; mkdir -p "$P"
sed "s#SpreadsheetApp.getActiveSpreadsheet()#SpreadsheetApp.openById('$SHEET_ID')#" apps-script.gs > "$P/Code.gs"
cat > "$P/appsscript.json" <<'JSON'
{"timeZone":"America/Sao_Paulo","exceptionLogging":"STACKDRIVER","runtimeVersion":"V8",
 "oauthScopes":["https://www.googleapis.com/auth/spreadsheets"],
 "webapp":{"access":"ANYONE_ANONYMOUS","executeAs":"USER_DEPLOYING"}}
JSON
echo "== 1/5 Ative a 'Google Apps Script API' (abrindo a página; troque para ATIVADO e volte aqui)"
xdg-open "https://script.google.com/home/usersettings" >/dev/null 2>&1 || true
read -r -p "Já ativou? (Enter) " _
echo "== 2/5 Login no Google (vai abrir o navegador; autorize com a conta dona da planilha)"
$CLASP login
echo "== 3/5 Criando o projeto ligado à planilha e enviando o código"
( cd "$P" && $CLASP create --type sheets --parentId "$SHEET_ID" --title "Revisão do catálogo (envio)" --rootDir . && $CLASP push -f )
echo "== 4/5 Publicando como app da Web"
( cd "$P" && $CLASP deploy --description "v1" )
DEP=$(cd "$P" && $CLASP deployments | grep -oE 'AKfy[A-Za-z0-9_-]+' | tail -1)
[ -n "$DEP" ] || { echo "Não achei o ID da implantação."; exit 1; }
URL="https://script.google.com/macros/s/$DEP/exec"
echo "URL: $URL"
echo "   Abrindo a URL: se o Google pedir autorização, autorize (Avançado > Acessar > Permitir). Depois volte aqui."
xdg-open "$URL" >/dev/null 2>&1 || true
read -r -p "Autorizou? (Enter) " _
echo "   Teste de envio (grava 1 linha '_teste_instalacao' na planilha; pode apagar depois):"
curl -sL -X POST -H "Content-Type: text/plain" -d '{"linhas":[{"revisor":"_teste_instalacao","enviado_em":"teste","id":"teste","tipo":"produto","setor":"teste","nome":"teste","texto":"pode apagar"}]}' "$URL"; echo
echo "== 5/5 Configurando a página e publicando no GitHub Pages"
./configurar-url.sh "$URL"
./publicar.sh
