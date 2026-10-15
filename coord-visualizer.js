const fs = require('fs');
const path = require('path');

const galP = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg';
const resP = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg';
const celP = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg';

const galB64 = fs.readFileSync(galP).toString('base64');
const resB64 = fs.readFileSync(resP).toString('base64');
const celB64 = fs.readFileSync(celP).toString('base64');

// We want to test different crop boxes:
// Notice each image is 1024x571.
// Let's create an interactive tool to preview any crop box and also preview how it looks inside #char-canvas-wrap (e.g. 400x240)
const html = `<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Coordinate Visualizer & Tester</title>
<style>
  body { background: #0c1017; color: #fff; font-family: sans-serif; margin: 0; padding: 20px; }
  h1 { font-size: 20px; color: #00f0b5; }
  .char-section { margin-bottom: 40px; border-bottom: 1px solid #333; padding-bottom: 30px; }
  .grid-container { display: flex; gap: 20px; align-items: flex-start; }
  .raw-box { position: relative; border: 2px solid #444; width: 1024px; height: 571px; flex-shrink: 0; }
  .raw-box img { width: 1024px; height: 571px; display: block; }
  .preview-stage { width: 380px; height: 230px; background: linear-gradient(180deg, #0b111e 0%, #111a2c 50%, #090e18 100%); border: 2px solid #00f0b5; position: relative; display: flex; justify-content: center; align-items: flex-end; overflow: hidden; }
  .preview-stage canvas { display: block; max-width: 100%; max-height: 100%; }
  .ctrl-box { background: #161e2e; padding: 15px; border-radius: 8px; width: 380px; font-size: 13px; }
  .ctrl-box label { display: block; margin: 6px 0; }
  .ctrl-box input { width: 60px; background: #0b0f17; color: #00f0b5; border: 1px solid #444; padding: 2px 5px; }
  .rect-overlay { position: absolute; border: 2px dashed #ff0055; pointer-events: none; box-sizing: border-box; }
  .rect-overlay.normal { border-color: #00f0b5; }
</style>
</head>
<body>
<h1>ハナゲ・タイムトライアル 新3キャラクター クロップ検証＆サイズ調整ツール</h1>

<div id="app"></div>

<script>
const charsData = [
  {
    name: '10s アクティブ・ギャル',
    id: 'gal',
    b64: "${galB64}",
    // initial guess
    normal: { sx: 110, sy: 70, sw: 320, sh: 500 },
    pain:   { sx: 580, sy: 70, sw: 320, sh: 500 }
  },
  {
    name: '20s 研究員お姉さん',
    id: 'res',
    b64: "${resB64}",
    normal: { sx: 110, sy: 70, sw: 320, sh: 500 },
    pain:   { sx: 580, sy: 70, sw: 320, sh: 500 }
  },
  {
    name: '30s セレブお姉様',
    id: 'cel',
    b64: "${celB64}",
    normal: { sx: 110, sy: 70, sw: 320, sh: 500 },
    pain:   { sx: 580, sy: 70, sw: 320, sh: 500 }
  }
];

const app = document.getElementById('app');

charsData.forEach((c, idx) => {
  const sec = document.createElement('div');
  sec.className = 'char-section';
  sec.innerHTML = \`
    <h2>\${c.name}</h2>
    <div class="grid-container">
      <div class="raw-box" id="raw-\${c.id}">
        <img src="data:image/jpeg;base64,\${c.b64}" id="img-\${c.id}" />
        <div class="rect-overlay normal" id="rect-norm-\${c.id}"></div>
        <div class="rect-overlay" id="rect-pain-\${c.id}"></div>
      </div>
      <div>
        <div class="ctrl-box">
          <h4>通常時 クロップ (緑点線)</h4>
          <label>sx: <input type="number" id="norm-sx-\${c.id}" value="\${c.normal.sx}"> sy: <input type="number" id="norm-sy-\${c.id}" value="\${c.normal.sy}"></label>
          <label>sw: <input type="number" id="norm-sw-\${c.id}" value="\${c.normal.sw}"> sh: <input type="number" id="norm-sh-\${c.id}" value="\${c.normal.sh}"></label>
          <h4>悶絶時 クロップ (赤点線)</h4>
          <label>sx: <input type="number" id="pain-sx-\${c.id}" value="\${c.pain.sx}"> sy: <input type="number" id="pain-sy-\${c.id}" value="\${c.pain.sy}"></label>
          <label>sw: <input type="number" id="pain-sw-\${c.id}" value="\${c.pain.sw}"> sh: <input type="number" id="pain-sh-\${c.id}" value="\${c.pain.sh}"></label>
        </div>
        <h4 style="margin: 10px 0 5px;">ゲーム画面描画プレビュー (通常時 / 悶絶時)</h4>
        <div style="display: flex; gap: 10px;">
          <div class="preview-stage"><canvas id="cv-norm-\${c.id}" width="380" height="230"></canvas></div>
          <div class="preview-stage"><canvas id="cv-pain-\${c.id}" width="380" height="230"></canvas></div>
        </div>
      </div>
    </div>
  \`;
  app.appendChild(sec);

  function update() {
    const norm = {
      sx: +document.getElementById(\`norm-sx-\${c.id}\`).value,
      sy: +document.getElementById(\`norm-sy-\${c.id}\`).value,
      sw: +document.getElementById(\`norm-sw-\${c.id}\`).value,
      sh: +document.getElementById(\`norm-sh-\${c.id}\`).value,
    };
    const pain = {
      sx: +document.getElementById(\`pain-sx-\${c.id}\`).value,
      sy: +document.getElementById(\`pain-sy-\${c.id}\`).value,
      sw: +document.getElementById(\`pain-sw-\${c.id}\`).value,
      sh: +document.getElementById(\`pain-sh-\${c.id}\`).value,
    };

    const rNorm = document.getElementById(\`rect-norm-\${c.id}\`);
    rNorm.style.left = norm.sx + 'px';
    rNorm.style.top = norm.sy + 'px';
    rNorm.style.width = norm.sw + 'px';
    rNorm.style.height = norm.sh + 'px';

    const rPain = document.getElementById(\`rect-pain-\${c.id}\`);
    rPain.style.left = pain.sx + 'px';
    rPain.style.top = pain.sy + 'px';
    rPain.style.width = pain.sw + 'px';
    rPain.style.height = pain.sh + 'px';

    const img = document.getElementById(\`img-\${c.id}\`);
    if (!img.complete) return;

    // render normal
    const cvN = document.getElementById(\`cv-norm-\${c.id}\`);
    const ctxN = cvN.getContext('2d');
    ctxN.clearRect(0, 0, 380, 230);
    const scaleN = Math.min(380 / norm.sw, 230 / norm.sh);
    const dW_N = norm.sw * scaleN;
    const dH_N = norm.sh * scaleN;
    ctxN.drawImage(img, norm.sx, norm.sy, norm.sw, norm.sh, (380 - dW_N) / 2, 230 - dH_N, dW_N, dH_N);

    // render pain
    const cvP = document.getElementById(\`cv-pain-\${c.id}\`);
    const ctxP = cvP.getContext('2d');
    ctxP.clearRect(0, 0, 380, 230);
    const scaleP = Math.min(380 / pain.sw, 230 / pain.sh);
    const dW_P = pain.sw * scaleP;
    const dH_P = pain.sh * scaleP;
    ctxP.drawImage(img, pain.sx, pain.sy, pain.sw, pain.sh, (380 - dW_P) / 2, 230 - dH_P, dW_P, dH_P);
  }

  ['norm-sx-', 'norm-sy-', 'norm-sw-', 'norm-sh-', 'pain-sx-', 'pain-sy-', 'pain-sw-', 'pain-sh-'].forEach(prefix => {
    document.getElementById(\`\${prefix}\${c.id}\`).addEventListener('input', update);
  });

  const img = document.getElementById(\`img-\${c.id}\`);
  img.onload = update;
});
</script>
</body>
</html>`;

fs.writeFileSync('C:/Users/sam/.gemini/antigravity/scratch/hanage-game/coord-visualizer.html', html, 'utf8');
console.log('coord-visualizer.html successfully created!');
