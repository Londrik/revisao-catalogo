# Revisão do catálogo (página para o pessoal conferir)

Página estática (`index.html` + `img/`). Quem recebe o link marca, por produto: **Tudo certo**, **Foto errada**,
**Descrição errada**, **Preço errado**, **Gramatura errada** ou **Tenho a foto**, escreve o certo e clica em **Salvar e enviar**.
As respostas caem numa planilha Google no seu Drive (reenviar atualiza as linhas do mesmo revisor, não duplica).

## 1. Planilha que recebe as respostas (5 min)
1. No Drive, crie uma planilha nova: "Revisão do catálogo — respostas".
2. Menu **Extensões → Apps Script**. Apague o que houver e cole o conteúdo de `apps-script.gs`. Salve.
3. **Implantar → Nova implantação → tipo "App da Web"**. Execute como: **Eu**. Quem pode acessar: **Qualquer pessoa**. Implantar e autorizar.
4. Copie a **URL do app da Web** (termina em `/exec`).
5. Abra `index.html`, procure `COLE_AQUI_A_URL_DO_APPS_SCRIPT` (uma vez, perto do fim) e troque pela URL. Salve.
   (Se esquecer isso, o botão "Salvar e enviar" baixa um CSV em vez de enviar.)

## 2. Publicar no GitHub Pages
1. Crie um repositório **separado do código da loja** (ex.: `revisao-catalogo`). Pages gratuito exige repositório público: qualquer pessoa com o link vê fotos e preços.
2. `git remote add origin <url-do-repo>` e `git push -u origin main` (o `git push` é com você).
3. No GitHub: **Settings → Pages → Branch: main, pasta / (root)**. O link sai em `https://<usuario>.github.io/revisao-catalogo/`.

## 3. Mandar o link
Peça para cada pessoa digitar o nome na primeira caixa. Sugestão: Luan → fotos; Emerson → descrições e preços.

## Atualizar a página
Os dados vêm do banco local. Para gerar de novo: `python3 -I ~/emporio-orquestra/lotes/build_site.py` (e refaça o passo 1.5).
