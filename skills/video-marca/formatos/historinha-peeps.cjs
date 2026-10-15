// Teste de consistência: 2 personagens Open Peeps (CC0) em 3 cenas 9:16 -> HTML por cena.
const path = require('path');
const fs = require('fs');
// npm i react-peeps@0.1.10 react@18.3.1 react-dom@18.3.1 numa pasta e aponte PEEPS_RT para o node_modules dela
const RT = process.env.PEEPS_RT || path.join(__dirname, '../peeps-rt/node_modules');
const React = require(path.join(RT, 'react'));
const { renderToStaticMarkup } = require(path.join(RT, 'react-dom/server'));
const Peep = require(path.join(RT, 'react-peeps')).default;

const ROXO = '#6C2BD9', ROXO_SOFT = '#F0EAFF', TINTA = '#212121';
// ficha fixa: só pose e expressão mudam entre cenas
const ANA = { hair: 'LongCurly', accessory: undefined, facialHair: undefined, backgroundColor: '#8D5524' };
const LEO = { hair: 'ShortVolumed', accessory: 'GlassRoundThick', facialHair: undefined, backgroundColor: '#F1C27D' };

const peep = (ficha, body, face, flip = false) => renderToStaticMarkup(
  React.createElement(Peep, {
    ...ficha, body, face, strokeColor: TINTA,
    viewBox: { x: '0', y: '0', width: '1500', height: '2400' }, // corpo inteiro
    style: { width: '100%', height: '100%', transform: flip ? 'scaleX(-1)' : undefined },
  }));

const fone = (conteudo) => `<div class="fone"><div class="tela">${conteudo}</div></div>`;
const cenas = [
  { id: 'c1', legenda: 'sexta-feira. nenhum plano.', fundo: '#EFEFEF',
    pessoas: [[ANA, 'RestingBW', 'Tired', false, 8, 52], [LEO, 'CrossedArmsBW', 'Concerned', true, 50, 50]] },
  { id: 'c2', legenda: 'abriu a BAZI.', fundo: ROXO_SOFT, fone: 'ana',
    pessoas: [[ANA, 'PointingFingerBW', 'Awe', false, 8, 54], [LEO, 'ShirtPantsBW', 'Suspicious', true, 50, 50]] },
  { id: 'c3', legenda: '"BORA?"', fundo: ROXO, tinta: '#fff',
    pessoas: [[ANA, 'RoboDanceBW', 'SmileBig', false, 6, 54], [LEO, 'WalkingBW', 'SmileLol', true, 44, 52]] },
];

const css = `*{margin:0;box-sizing:border-box}body{width:1080px;height:1920px;overflow:hidden;font-family:-apple-system,Helvetica,sans-serif}
.cena{position:relative;width:1080px;height:1920px}
.p{position:absolute;bottom:120px;height:1250px}
.leg{position:absolute;top:220px;left:0;right:0;text-align:center;font-weight:800;font-size:84px;letter-spacing:-2px}
.fone{position:absolute;left:330px;top:470px;width:250px;height:470px;border:8px solid #212121;border-radius:40px;background:#fff;transform:rotate(-8deg);box-shadow:0 20px 40px #0003}
.tela{position:absolute;inset:14px;border-radius:26px;background:${ROXO};color:#fff;font-weight:900;font-size:46px;display:grid;place-items:center}`;

fs.mkdirSync(path.join(process.cwd(), 'out'), { recursive: true });
for (const c of cenas) {
  const ps = c.pessoas.map(([f, body, face, flip, left, w]) =>
    `<div class="p" style="left:${left}%;width:${w}%">${peep(f, body, face, flip)}</div>`).join('');
  const html = `<!doctype html><meta charset="utf-8"><style>${css}</style>
<div class="cena" style="background:${c.fundo}"><div class="leg" style="color:${c.tinta || TINTA}">${c.legenda}</div>${ps}${c.fone ? fone('BAZI') : ''}</div>`;
  fs.writeFileSync(path.join(process.cwd(), 'out', c.id + '.html'), html);
}
console.log('ok', cenas.length);
