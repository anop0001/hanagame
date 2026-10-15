const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/sam/.gemini/antigravity/scratch/hanage-game';
const pGal = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg';
const pRes = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg';
const pCel = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg';
const pFavPc = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792082733404_4ef1f029.jpg';
const pFavSp = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792082733477_cff0aa8f.jpg';

const b64Gal = fs.readFileSync(pGal).toString('base64');
const b64Res = fs.readFileSync(pRes).toString('base64');
const b64Cel = fs.readFileSync(pCel).toString('base64');
const b64FavPc = fs.readFileSync(pFavPc).toString('base64');
const b64FavSp = fs.readFileSync(pFavSp).toString('base64');

// 静的アイコン・OGP画像ファイルも出力（Vercel等のクローラーおよび直接参照用）
fs.copyFileSync(pFavPc, path.join(dir, 'favicon.png'));
fs.copyFileSync(pFavPc, path.join(dir, 'favicon.ico'));
fs.copyFileSync(pFavSp, path.join(dir, 'apple-touch-icon.png'));
fs.copyFileSync(pFavSp, path.join(dir, 'og-image.jpg'));

let template = fs.readFileSync(path.join(dir, 'template.html'), 'utf8');
template = template.replace('__ASSET_GAL_B64__', b64Gal);
template = template.replace('__ASSET_RES_B64__', b64Res);
template = template.replace('__ASSET_CEL_B64__', b64Cel);
template = template.replace(/__FAVICON_PC_B64__/g, b64FavPc);
template = template.replace(/__FAVICON_SP_B64__/g, b64FavSp);

const targetFile = path.join(dir, 'hanage-game.html');
fs.writeFileSync(targetFile, template, 'utf8');

const indexFile = path.join(dir, 'index.html');
fs.writeFileSync(indexFile, template, 'utf8');

const stat = fs.statSync(targetFile);
console.log('hanage-game.html and index.html generated successfully! File size:', stat.size, 'bytes');
console.log('Static favicon/icon files exported successfully!');
