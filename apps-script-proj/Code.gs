// Google Apps Script — recebe as respostas da página de revisão e grava numa planilha.
// Como usar: veja LEIA-ME.md (passo a passo). Cole este código em Extensões > Apps Script de uma planilha nova.
const ABA = "Respostas";
const COLS = ["revisor","enviado_em","id","tipo","setor","nome","situacao_atual","tudo_certo","foto_errada","descricao_errada","preco_errado","gramatura_errada","tenho_a_foto","produto_novo","ignorar","texto"];

function doPost(e) {
  const lock = LockService.getScriptLock(); lock.waitLock(20000);
  try {
    const dados = JSON.parse(e.postData.contents);
    const linhas = (dados.linhas || []).slice(0, 1000);
    const ss = SpreadsheetApp.openById('174N08L1l78FeZ5zTh9RnempWkPCd61QZ2bhMkWJMt2E');
    const sh = ss.getSheetByName(ABA) || ss.insertSheet(ABA);
    if (sh.getLastRow() === 0) sh.appendRow(COLS);
    const existentes = sh.getLastRow() > 1 ? sh.getRange(2, 1, sh.getLastRow() - 1, 3).getValues() : [];
    const indice = {}; existentes.forEach((r, i) => indice[r[0] + "|" + r[2]] = i + 2);   // revisor|id -> linha
    linhas.forEach(l => {
      const valores = COLS.map(c => String(l[c] === undefined ? "" : l[c]).slice(0, 2000));
      const chave = l.revisor + "|" + l.id;
      if (indice[chave]) sh.getRange(indice[chave], 1, 1, COLS.length).setValues([valores]);   // reenvio atualiza
      else sh.appendRow(valores);
    });
    return ContentService.createTextOutput(JSON.stringify({ok: true, recebidas: linhas.length})).setMimeType(ContentService.MimeType.JSON);
  } finally { lock.releaseLock(); }
}
function doGet() { return ContentService.createTextOutput("ok"); }
