const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/sam/.gemini/antigravity/scratch/hanage-game';
const pGal = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548580_a28ecefa.jpg';
const pRes = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548573_57b87a28.jpg';
const pCel = 'C:/Users/sam/.gemini/antigravity/brain/7af71346-43bc-434c-ba68-9c0de09bfc51/.user_uploaded/media_1792074548589_cf192fb4.jpg';

const b64Gal = fs.readFileSync(pGal).toString('base64');
const b64Res = fs.readFileSync(pRes).toString('base64');
const b64Cel = fs.readFileSync(pCel).toString('base64');

let template = fs.readFileSync(path.join(dir, 'template.html'), 'utf8');
template = template.replace('__ASSET_GAL_B64__', b64Gal);
template = template.replace('__ASSET_RES_B64__', b64Res);
template = template.replace('__ASSET_CEL_B64__', b64Cel);

const targetFile = path.join(dir, 'hanage-game.html');
fs.writeFileSync(targetFile, template, 'utf8');

const stat = fs.statSync(targetFile);
console.log('hanage-game.html generated successfully! File size:', stat.size, 'bytes');
