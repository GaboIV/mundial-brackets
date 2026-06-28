/* ============================================================
   QUINIELA MUNDIAL 2026 — app.js
   Frontend estático (GitHub Pages) + Supabase (datos/Auth/RLS).
   ============================================================ */

/* ====== CONFIG SUPABASE (rellena con tus claves del proyecto) ======
   Si las dejas con el placeholder, la app corre en MODO LOCAL (sin nube). */
const SUPABASE_URL      = 'https://halkkiffurzonxzpnftk.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_Q0u2VRFCcr5rb7QhrZIcKw_D-ungQKv';

let sb = null;
const SB_READY = SUPABASE_URL.startsWith('https://') && !SUPABASE_URL.includes('TU-PROYECTO');
try{
  if(SB_READY && window.supabase){ sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY); }
}catch(e){ console.warn('Supabase no inicializado:', e); }

/* ============================================================
   DATOS
   ============================================================ */
const flagUrl    = c => `https://flagcdn.com/w160/${c}.png`;
const flagSrcset = c => `https://flagcdn.com/w320/${c}.png 2x`;

/* ============================================================
   GEOMETRÍA DEL BRACKET
   ============================================================ */
const W = 1180, H = 1120;
const STAGE_H = 1150;
const CH = 46;
const topPad = 112;
const step = 118;
const OFF = 28;

const COL = {
  r32:{x:14,  w:84},
  r16:{x:148, w:76},
  qf: {x:274, w:70},
  sf: {x:394, w:64}
};
const FINAL = {w:76, y:577};
const finalLeftX  = W/2 - 7 - FINAL.w;
const finalRightX = W/2 + 7;

const CHAMP = {w:180, h:60, labelTop:772, labelH:26};
const champX  = W/2 - CHAMP.w/2;
const champCy = CHAMP.labelTop + CHAMP.labelH + CHAMP.h/2;

const r32c = i => topPad + (i + 0.5) * step;
const avg = (a,b) => (a + b) / 2;

/* ============================================================
   16vos BLOQUEADOS (equipos fijos)
   ============================================================ */
const tm = (c,n) => ({c,n});
const DEFAULTS = {
  'L-r32-0-0':tm('de','Alemania'),      'L-r32-0-1':tm('py','Paraguay'),
  'L-r32-1-0':tm('fr','Francia'),       'L-r32-1-1':tm('se','Suecia'),
  'L-r32-2-0':tm('za','Sudáfrica'),     'L-r32-2-1':tm('ca','Canadá'),
  'L-r32-3-0':tm('nl','Países Bajos'),  'L-r32-3-1':tm('ma','Marruecos'),
  'L-r32-4-0':tm('pt','Portugal'),      'L-r32-4-1':tm('hr','Croacia'),
  'L-r32-5-0':tm('es','España'),        'L-r32-5-1':tm('at','Austria'),
  'L-r32-6-0':tm('us','Estados Unidos'),'L-r32-6-1':tm('ba','Bosnia y Herzegovina'),
  'L-r32-7-0':tm('be','Bélgica'),       'L-r32-7-1':tm('sn','Senegal'),
  'R-r32-0-0':tm('br','Brasil'),        'R-r32-0-1':tm('jp','Japón'),
  'R-r32-1-0':tm('ci','Costa de Marfil'),'R-r32-1-1':tm('no','Noruega'),
  'R-r32-2-0':tm('mx','México'),        'R-r32-2-1':tm('ec','Ecuador'),
  'R-r32-3-0':tm('gb-eng','Inglaterra'),'R-r32-3-1':tm('cd','RD Congo'),
  'R-r32-4-0':tm('ar','Argentina'),     'R-r32-4-1':tm('cv','Cabo Verde'),
  'R-r32-5-0':tm('au','Australia'),     'R-r32-5-1':tm('eg','Egipto'),
  'R-r32-6-0':tm('ch','Suiza'),         'R-r32-6-1':tm('dz','Argelia'),
  'R-r32-7-0':tm('co','Colombia'),      'R-r32-7-1':tm('gh','Ghana')
};

/* ============================================================
   ESTADO
   ============================================================ */
// Mi bracket: ganadores (winners) + marcadores (scores). r32 vienen de DEFAULTS.
const state  = Object.assign({}, DEFAULTS);   // winners por slot
const scores = {};                            // { slotId:[g0,g1] }
let currentId = null;                          // partido abierto en el modal

// Bracket oficial (admin)
const offW = Object.assign({}, DEFAULTS);
const offS = {};

// Objeto que el modal está editando (mi bracket por defecto)
let editTarget = { W: state, S: scores, kind: 'mine' };

// Config remota
const DEFAULT_SCORING = {r16:1,qf:2,sf:4,fin:6,champ:10,exact:3,diff:1};
let settings = { locked:false, late_register_only:false, scoring:{...DEFAULT_SCORING} };
let officialResults = { winners:{}, scores:{} };
let adminMode = false;

/* ============================================================
   CONSTRUCCIÓN DE CASILLAS
   ============================================================ */
function buildChips(){
  const chips = [];
  const r32centers = [...Array(8)].map((_,i)=>r32c(i));
  const r16centers = [0,1,2,3].map(j=>avg(r32centers[2*j], r32centers[2*j+1]));
  const qfcenters  = [0,1].map(k=>avg(r16centers[2*k], r16centers[2*k+1]));
  const sfcenters  = qfcenters;

  ['L','R'].forEach(side=>{
    const mx = (x,w)=> side==='L' ? x : (W - x - w);
    for(let i=0;i<8;i++){
      const c = r32centers[i];
      chips.push({id:`${side}-r32-${i}-0`, x:mx(COL.r32.x,COL.r32.w), w:COL.r32.w, cy:c-OFF, round:'r32'});
      chips.push({id:`${side}-r32-${i}-1`, x:mx(COL.r32.x,COL.r32.w), w:COL.r32.w, cy:c+OFF, round:'r32'});
    }
    for(let i=0;i<8;i++){
      chips.push({id:`${side}-r16-${i}`, x:mx(COL.r16.x,COL.r16.w), w:COL.r16.w, cy:r32centers[i], round:'r16'});
    }
    for(let j=0;j<4;j++){
      chips.push({id:`${side}-qf-${j}`, x:mx(COL.qf.x,COL.qf.w), w:COL.qf.w, cy:r16centers[j], round:'qf'});
    }
    for(let k=0;k<2;k++){
      chips.push({id:`${side}-sf-${k}`, x:mx(COL.sf.x,COL.sf.w), w:COL.sf.w, cy:sfcenters[k], round:'sf'});
    }
  });
  chips.push({id:'L-fin', x:finalLeftX,  w:FINAL.w, cy:FINAL.y+CH/2, round:'fin'});
  chips.push({id:'R-fin', x:finalRightX, w:FINAL.w, cy:FINAL.y+CH/2, round:'fin'});
  chips.push({id:'champ', x:champX, w:CHAMP.w, cy:champCy, h:CHAMP.h, round:'champ'});

  return {chips, r32centers, r16centers, qfcenters};
}
const G = buildChips();
const ADV_SLOTS = G.chips.filter(c=>c.round!=='r32').map(c=>c.id); // 31 partidos

/* ============================================================
   ESTRUCTURA DE LLAVES
   ============================================================ */
function feedersOf(id){
  if(id==='champ')  return ['L-fin','R-fin'];
  if(id==='L-fin')  return ['L-sf-0','L-sf-1'];
  if(id==='R-fin')  return ['R-sf-0','R-sf-1'];
  const m = id.match(/^([LR])-(r16|qf|sf)-(\d+)$/);
  if(!m) return null;
  const side=m[1], round=m[2], n=+m[3];
  if(round==='sf')  return [`${side}-qf-${2*n}`,  `${side}-qf-${2*n+1}`];
  if(round==='qf')  return [`${side}-r16-${2*n}`, `${side}-r16-${2*n+1}`];
  if(round==='r16') return [`${side}-r32-${n}-0`, `${side}-r32-${n}-1`];
  return null;
}
function parentOf(id){
  if(id==='champ') return null;
  if(id==='L-fin'||id==='R-fin') return 'champ';
  const m = id.match(/^([LR])-(r16|qf|sf)-(\d+)$/);
  if(m){
    const side=m[1], round=m[2], n=+m[3];
    if(round==='sf')  return `${side}-fin`;
    if(round==='qf')  return `${side}-sf-${Math.floor(n/2)}`;
    if(round==='r16') return `${side}-qf-${Math.floor(n/2)}`;
  }
  const r = id.match(/^([LR])-r32-(\d+)-\d+$/);
  if(r) return `${r[1]}-r16-${r[2]}`;
  return null;
}
function roundOf(id){
  if(id==='champ') return 'champ';
  if(id.endsWith('-fin')) return 'fin';
  if(id.includes('-sf-')) return 'sf';
  if(id.includes('-qf-')) return 'qf';
  if(id.includes('-r16-')) return 'r16';
  return 'r32';
}
function sameTeam(a,b){ if(!a||!b) return false; return a.c ? a.c===b.c : (!b.c && a.n===b.n); }
function teamEq(a,b){ return !!a && !!b && !!a.c && a.c===b.c; }

// Al cambiar el ganador de `id`, borra hacia arriba ganadores Y marcadores que
// arrastraban al equipo viejo (su cruce ya no es válido).
function clearStaleAncestors(Wm, Sm, id, oldTeam){
  let cur=id, p=parentOf(cur);
  while(p){
    if(Wm[p] && sameTeam(Wm[p], oldTeam)){ delete Wm[p]; if(Sm) delete Sm[p]; cur=p; p=parentOf(cur); }
    else break;
  }
}

/* ============================================================
   CONECTORES + FONDO (SVG, una sola vez)
   ============================================================ */
function svgLine(d){ return `<path d="${d}" fill="none" stroke="var(--line)" stroke-width="1.6"/>`; }
function pairPath(side, c1y, c2y, childEdgeX, parentX, parentY, parentW){
  let lines = '';
  const cx = childEdgeX;
  const px = side==='L' ? parentX : (parentX + parentW);
  const midX = (cx + px)/2;
  lines += svgLine(`M ${cx} ${c1y} H ${midX}`);
  lines += svgLine(`M ${cx} ${c2y} H ${midX}`);
  lines += svgLine(`M ${midX} ${c1y} V ${c2y}`);
  lines += svgLine(`M ${midX} ${parentY} H ${px}`);
  return lines;
}
function findChip(id){ return G.chips.find(c=>c.id===id); }

function drawBackground(){
  const svg = document.getElementById('bgwaves');
  const N = 26, spacing = H/(N-1);
  let out = '';
  for(let i=0;i<N;i++){
    const baseY = i*spacing;
    const amp   = 14 + (i%5)*5;
    const freq  = (2.0 + (i%3)*0.7) * Math.PI / W;
    const phase = i*0.8;
    const tilt  = ((i%2)?1:-1) * (i*0.6);
    let d = '';
    for(let x=0;x<=W;x+=18){
      const y = baseY + tilt*(x/W) + amp*Math.sin(x*freq + phase);
      d += (x===0?'M ':'L ') + x + ' ' + y.toFixed(1) + ' ';
    }
    const op = (0.04 + (i%4)*0.013).toFixed(3);
    out += `<path d="${d.trim()}" fill="none" stroke="#ffffff" stroke-width="1" opacity="${op}"/>`;
  }
  svg.innerHTML = out;
}
function drawConnectors(){
  const svg = document.getElementById('connectors');
  let out = '';
  ['L','R'].forEach(side=>{
    for(let i=0;i<8;i++){
      const a=findChip(`${side}-r32-${i}-0`), b=findChip(`${side}-r32-${i}-1`), p=findChip(`${side}-r16-${i}`);
      const cEdge = side==='L' ? a.x+a.w : a.x;
      out += pairPath(side, a.cy, b.cy, cEdge, p.x, p.cy, p.w);
    }
    for(let j=0;j<4;j++){
      const a=findChip(`${side}-r16-${2*j}`), b=findChip(`${side}-r16-${2*j+1}`), p=findChip(`${side}-qf-${j}`);
      const cEdge = side==='L' ? a.x+a.w : a.x;
      out += pairPath(side, a.cy, b.cy, cEdge, p.x, p.cy, p.w);
    }
    for(let k=0;k<2;k++){
      const a=findChip(`${side}-qf-${2*k}`), b=findChip(`${side}-qf-${2*k+1}`), p=findChip(`${side}-sf-${k}`);
      const cEdge = side==='L' ? a.x+a.w : a.x;
      out += pairPath(side, a.cy, b.cy, cEdge, p.x, p.cy, p.w);
    }
  });
  const Lsf0=findChip('L-sf-0'), Lsf1=findChip('L-sf-1'), Lf=findChip('L-fin');
  const Rsf0=findChip('R-sf-0'), Rsf1=findChip('R-sf-1'), Rf=findChip('R-fin');
  const lsfEdge = Lsf0.x + Lsf0.w;
  const lbx = (lsfEdge + Lf.x) / 2;
  out += svgLine(`M ${lsfEdge} ${Lsf0.cy} H ${lbx}`);
  out += svgLine(`M ${lsfEdge} ${Lsf1.cy} H ${lbx}`);
  out += svgLine(`M ${lbx} ${Lsf0.cy} V ${Lsf1.cy}`);
  out += svgLine(`M ${lbx} ${Lf.cy} H ${Lf.x}`);
  const rsfEdge = Rsf0.x;
  const rbx = (rsfEdge + (Rf.x + Rf.w)) / 2;
  out += svgLine(`M ${rsfEdge} ${Rsf0.cy} H ${rbx}`);
  out += svgLine(`M ${rsfEdge} ${Rsf1.cy} H ${rbx}`);
  out += svgLine(`M ${rbx} ${Rsf0.cy} V ${Rsf1.cy}`);
  out += svgLine(`M ${rbx} ${Rf.cy} H ${Rf.x+Rf.w}`);
  out += `<path d="M ${Lf.x+Lf.w} ${Lf.cy} H ${Rf.x}" fill="none" stroke="var(--line-gold)" stroke-width="1.6"/>`;
  out += `<path d="M ${W/2} 712 V ${CHAMP.labelTop}" fill="none" stroke="var(--gold)" stroke-width="2"/>`;
  svg.innerHTML = out;
}

/* ============================================================
   RENDER DEL BRACKET (genérico: mío / oficial / de otro)
   ============================================================ */
function escapeHtml(s){return String(s).replace(/[&<>"]/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[m]));}

// data = { W:winners, S:scores }. Si editable, cada partido abre el modal.
function renderStage(data, editable){
  const Wm = data.W, Sm = data.S;
  const stage = document.getElementById('stage');
  stage.querySelectorAll('.chip').forEach(e=>e.remove());
  G.chips.forEach(c=>{
    const h = c.h || CH;
    const el = document.createElement('div');
    el.className = 'chip' + (c.round==='fin'?' fin':'') + (c.round==='champ'?' champ':'');
    el.style.left = c.x+'px';
    el.style.top  = (c.cy - h/2)+'px';
    el.style.width = c.w+'px';
    el.style.height = h+'px';
    el.dataset.id = c.id;
    paintChip(el, c.id, Wm);
    // marcador: el gol de este equipo en el partido que jugó para avanzar (su "padre")
    const par = parentOf(c.id);
    if(par && Sm[par]){
      const f = feedersOf(par);
      const idx = f ? f.indexOf(c.id) : -1;
      if(idx>=0 && Sm[par][idx]!=null){
        const g = document.createElement('span');
        g.className = 'goal';
        g.textContent = Sm[par][idx];
        el.appendChild(g);
      }
    }
    const isPlayed = data.kind !== 'official' && c.round !== 'r32' && officialResults.winners && officialResults.winners[c.id] && officialResults.winners[c.id].c;
    if(c.round==='r32'){
      el.classList.add('locked');
    }else if(isPlayed){
      el.classList.add('played-locked');
      el.title = 'Partido ya jugado (bloqueado)';
    }else if(editable){
      el.addEventListener('click', ()=>openMatch(c.id));
    }else{
      el.classList.add('readonly');
    }
    stage.appendChild(el);
  });
  updateProgress(Wm, Sm);
}

function paintChip(el, id, Wm){
  const data = Wm[id];
  if(id==='champ' && data && data.c){
    el.classList.remove('empty');
    el.title = data.n || '';
    el.innerHTML = `<div class="winwrap">
      <img class="wflag" crossorigin="anonymous" src="${flagUrl(data.c)}" srcset="${flagSrcset(data.c)}" alt="">
      <span class="cn">${escapeHtml(data.n||'')}</span></div>`;
  }else if(data && data.c){
    el.classList.remove('empty');
    el.title = data.n || '';
    el.innerHTML = `<img class="flag" crossorigin="anonymous" src="${flagUrl(data.c)}" srcset="${flagSrcset(data.c)}" alt="${escapeHtml(data.n||'')}">`;
  }else if(data && data.n){
    el.classList.remove('empty');
    el.title = data.n;
    el.innerHTML = `<span class="nm">${escapeHtml(data.n)}</span>`;
  }else{
    el.classList.add('empty');
    el.title = '';
    el.innerHTML = `<span class="plus">+</span>`;
  }
}

// Cuántos de los 31 partidos están completos (ganador + marcador)
function isMatchDone(Wm, Sm, slot){
  return !!(Wm[slot] && Wm[slot].c && Sm[slot] && Sm[slot].length===2 &&
            Number.isInteger(Sm[slot][0]) && Number.isInteger(Sm[slot][1]));
}
function updateProgress(Wm, Sm){
  const done = ADV_SLOTS.filter(s=>isMatchDone(Wm,Sm,s)).length;
  const pill = document.getElementById('counterPill');
  if(pill) pill.textContent = `${done} / 31`;
}

/* ============================================================
   MODAL: marcador + quién avanza
   ============================================================ */
const modalBg = document.getElementById('modalBg');
let penSel = null;   // ganador elegido por penales (fid) cuando hay empate

function openMatch(slot){
  if(!editTarget || slot.includes('-r32-')) return;
  const f = feedersOf(slot);
  if(!f) return;
  const Wm = editTarget.W, Sm = editTarget.S;
  const t0 = Wm[f[0]], t1 = Wm[f[1]];
  if(!(t0&&t0.c) || !(t1&&t1.c)){
    // un equipo aún no está definido (falta completar el partido anterior)
    renderMatchPending(slot, f, Wm);
    currentId = slot;
    modalBg.classList.add('open');
    return;
  }
  currentId = slot;
  const sc = Sm[slot] || [null,null];
  penSel = null;
  // si el ganador guardado era por penales (empate), recuérdalo
  if(sc[0]!=null && sc[0]===sc[1] && Wm[slot] && Wm[slot].c){
    penSel = teamEq(Wm[slot], t0) ? f[0] : (teamEq(Wm[slot], t1) ? f[1] : null);
  }
  renderMatch(slot, f, [t0,t1], sc);
  modalBg.classList.add('open');
}

function teamRow(fid, team, side, goals){
  const flag = team.c ? `<img crossorigin="anonymous" src="${flagUrl(team.c)}" srcset="${flagSrcset(team.c)}" alt="">` : '';
  return `<div class="mteam" data-fid="${fid}" data-side="${side}">
      ${flag}<span class="mname">${escapeHtml(team.n||'')}</span>
      <input class="goal-in" id="g${side}" type="number" min="0" max="99" inputmode="numeric"
             value="${goals!=null?goals:''}" placeholder="-">
    </div>`;
}
function renderMatch(slot, f, teams, sc){
  document.getElementById('modalTitle').textContent = roundName(slot);
  document.getElementById('modalSub').textContent = 'Pon el marcador y quién avanza';
  document.getElementById('matchBox').innerHTML =
    teamRow(f[0], teams[0], 0, sc[0]) + teamRow(f[1], teams[1], 1, sc[1]);
  document.getElementById('btnSaveMatch').style.display = '';
  document.getElementById('btnClear').style.display = '';
  document.querySelectorAll('#matchBox .goal-in').forEach(inp=>{
    inp.addEventListener('input', refreshPenalty);
  });
  // info de penales
  matchTeams = teams; matchFeeders = f;
  refreshPenalty();
}
function renderMatchPending(slot, f, Wm){
  document.getElementById('modalTitle').textContent = roundName(slot);
  document.getElementById('modalSub').textContent = 'Primero completa los partidos anteriores';
  const names = f.map(fid => (Wm[fid] && Wm[fid].c) ? escapeHtml(Wm[fid].n) : '<i>por definir</i>');
  document.getElementById('matchBox').innerHTML =
    `<div class="pending">${names[0]}<br>vs<br>${names[1]}</div>`;
  document.getElementById('penRow').hidden = true;
  document.getElementById('btnSaveMatch').style.display = 'none';
  document.getElementById('btnClear').style.display = (Wm[slot]?'':'none');
}
let matchTeams = null, matchFeeders = null;

function readGoals(){
  const a = document.getElementById('g0'), b = document.getElementById('g1');
  const ga = a && a.value!=='' ? parseInt(a.value,10) : null;
  const gb = b && b.value!=='' ? parseInt(b.value,10) : null;
  return [ga, gb];
}
function refreshPenalty(){
  const [ga,gb] = readGoals();
  const row = document.getElementById('penRow');
  if(ga!=null && gb!=null && ga===gb){
    // empate → hay que elegir quién pasa por penales
    row.hidden = false;
    row.innerHTML = `<span>Empate ${ga}-${gb}. ¿Quién pasa por penales?</span>` +
      matchFeeders.map((fid,i)=>`<button type="button" class="pen-btn ${penSel===fid?'sel':''}" data-fid="${fid}">${escapeHtml(matchTeams[i].n)}</button>`).join('');
    row.querySelectorAll('.pen-btn').forEach(b=>b.addEventListener('click',()=>{
      penSel = b.dataset.fid; refreshPenalty();
    }));
  }else{
    row.hidden = true; row.innerHTML = '';
    if(ga!=null && gb!=null) penSel = null;
  }
}
function roundName(slot){
  return {r16:'Dieciseisavos', qf:'Octavos', sf:'Cuartos', fin:'Semifinal', champ:'FINAL'}[roundOf(slot)] || 'Partido';
}

function saveMatch(){
  if(!currentId) return;
  const slot = currentId;
  const [ga,gb] = readGoals();
  if(ga==null || gb==null || ga<0 || gb<0){ alert('Pon el marcador de los dos equipos.'); return; }
  let winnerFid;
  if(ga>gb) winnerFid = matchFeeders[0];
  else if(gb>ga) winnerFid = matchFeeders[1];
  else{
    if(!penSel){ alert('Es empate: elige quién pasa por penales.'); return; }
    winnerFid = penSel;
  }
  const Wm = editTarget.W, Sm = editTarget.S;
  const winnerTeam = Wm[winnerFid];
  const old = Wm[slot];
  Wm[slot] = { c:winnerTeam.c||'', n:winnerTeam.n||'' };
  Sm[slot] = [ga, gb];
  if(old && !sameTeam(old, Wm[slot])) clearStaleAncestors(Wm, Sm, slot, old);
  afterEdit();
  closeModal();
}
function clearMatch(){
  if(!currentId) return;
  const slot = currentId;
  const Wm = editTarget.W, Sm = editTarget.S;
  const old = Wm[slot];
  delete Wm[slot]; delete Sm[slot];
  if(old) clearStaleAncestors(Wm, Sm, slot, old);
  afterEdit();
  closeModal();
}
function afterEdit(){
  renderStage(editTarget, true);
  if(editTarget.kind==='mine') saveLocal();
}
function closeModal(){ modalBg.classList.remove('open'); currentId=null; penSel=null; }

/* ============================================================
   PERSISTENCIA LOCAL (mi bracket) + token
   ============================================================ */
const LS_KEY = 'quiniela26';
const TOKEN_KEY = 'quiniela26_token';
function myToken(){
  let t = localStorage.getItem(TOKEN_KEY);
  if(!t){ t = (crypto.randomUUID ? crypto.randomUUID() : String(Date.now())+Math.random()); localStorage.setItem(TOKEN_KEY, t); }
  return t;
}
function saveLocal(){
  const name = (document.getElementById('nameInput')||{}).value || '';
  localStorage.setItem(LS_KEY, JSON.stringify({winners:advOnly(state), scores, name}));
}
function loadLocal(){
  try{
    const raw = localStorage.getItem(LS_KEY); if(!raw) return;
    const obj = JSON.parse(raw);
    Object.assign(state, obj.winners||{});
    Object.assign(scores, obj.scores||{});
    if(obj.name){ const ni=document.getElementById('nameInput'); if(ni){ ni.value=obj.name; applyName(obj.name); } }
  }catch(e){}
}
// solo slots de avance (sin r32) para enviar/guardar
function advOnly(Wm){
  const o={}; for(const k in Wm){ if(!k.includes('-r32-')) o[k]=Wm[k]; } return o;
}
function applyName(t){
  const sub=document.getElementById('subTitle');
  if(sub) sub.textContent = (t&&t.trim()) ? t.toUpperCase() : 'TU BRACKET';
}

/* ============================================================
   SUPABASE: settings / submit / fetch / admin
   ============================================================ */
async function loadSettings(){
  if(!sb) return;
  const { data, error } = await sb.from('settings').select('locked,scoring,late_register_only').eq('id',1).single();
  if(!error && data){
    settings.locked = !!data.locked;
    settings.late_register_only = !!data.late_register_only;
    settings.scoring = Object.assign({...DEFAULT_SCORING}, data.scoring||{});
  }
}
async function submitMyBracket(){
  const name = (document.getElementById('nameInput').value||'').trim();
  const status = document.getElementById('miStatus');
  if(!name){ alert('Escribe tu nombre.'); return; }
  const missing = ADV_SLOTS.filter(s => {
    const isOfficialDone = officialResults.winners && officialResults.winners[s] && officialResults.winners[s].c;
    return !isMatchDone(state,scores,s) && !isOfficialDone;
  });
  if(missing.length){ alert(`Te faltan ${missing.length} partidos por completar (ganador + marcador).`); return; }
  if(!sb){ saveLocal(); status.textContent='Guardado localmente (sin nube configurada).'; return; }
  if(settings.locked){ alert('El torneo está cerrado.'); return; }
  status.textContent='Guardando…';
  const payload = { winners:advOnly(state), scores };
  const { error } = await sb.rpc('submit_bracket', { p_token:myToken(), p_name:name, p_picks:payload });
  if(error){ status.textContent='Error: '+error.message; return; }
  saveLocal();
  status.textContent='¡Guardado! Puedes editar mientras el torneo siga abierto.';
}
async function fetchBrackets(){
  if(!sb) return [];
  const { data, error } = await sb.from('brackets').select('id,name,picks,updated_at').order('name');
  if(error){ console.warn(error); return []; }
  return data||[];
}
async function fetchOfficial(){
  if(!sb) return { winners:{}, scores:{} };
  const { data, error } = await sb.from('official').select('picks').eq('id',1).single();
  if(error || !data){ return { winners:{}, scores:{} }; }
  return data.picks || { winners:{}, scores:{} };
}

/* ============================================================
   PUNTAJE
   ============================================================ */
function scoreBracket(bw, bs, ow, os, weights){
  const Wm  = {...DEFAULTS, ...(bw||{})};
  const OWm = {...DEFAULTS, ...(ow||{})};
  const Sm = bs||{}, OSm = os||{};
  let adv=0, sc=0, hitsAdv=0, hitsExact=0, hitsDiff=0;
  for(const slot of ADV_SLOTS){
    if(OWm[slot] && OWm[slot].c){
      if(Wm[slot] && Wm[slot].c === OWm[slot].c){ adv += (weights[roundOf(slot)]||0); hitsAdv++; }
    }
    const f = feedersOf(slot);
    if(f && OSm[slot] && Sm[slot]){
      const lockMatch = teamEq(Wm[f[0]],OWm[f[0]]) && teamEq(Wm[f[1]],OWm[f[1]]);
      if(lockMatch){
        const a=Sm[slot][0], b=Sm[slot][1], A=OSm[slot][0], B=OSm[slot][1];
        if(a===A && b===B){ sc += (weights.exact||0); hitsExact++; }
        else if((a-b)===(A-B)){ sc += (weights.diff||0); hitsDiff++; }
      }
    }
  }
  return { adv, sc, total:adv+sc, hitsAdv, hitsExact, hitsDiff };
}

/* ============================================================
   NAVEGACIÓN (pestañas por hash)
   ============================================================ */
const TABS = ['mi','tabla','brackets'];
function moveStageTo(slotId){
  const scroller = document.getElementById('scroller');
  const host = document.getElementById(slotId);
  if(host && scroller.parentElement !== host){ host.appendChild(scroller); }
}
function setActiveTab(tab){
  document.querySelectorAll('#topnav [data-tab]').forEach(b=>b.classList.toggle('active', b.dataset.tab===tab));
}
function showPage(id){
  document.querySelectorAll('.page').forEach(p=>p.hidden = (p.id!==id));
}
async function route(){
  const h = (location.hash||'').replace('#','');
  if(h==='admin'){ setActiveTab(''); showPage('page-admin'); renderAdmin(); return; }
  const tab = TABS.includes(h) ? h : 'mi';
  setActiveTab(tab);
  showPage('page-'+tab);
  if(tab==='mi') showMine();
  else if(tab==='tabla') showTabla();
  else if(tab==='brackets') showBrackets();
}
window.addEventListener('hashchange', route);

function lockBadge(){
  const b=document.getElementById('lockBadge'); if(b) b.hidden = !settings.locked;
}

/* ---- Pestaña Mi Bracket ---- */
function showMine(){
  editTarget = { W:state, S:scores, kind:'mine' };
  moveStageTo('slot-mi');
  const locked = settings.locked;
  const lateRegister = settings.late_register_only;
  const hasLocalSaved = localStorage.getItem(LS_KEY) !== null;
  const isUserLocked = locked || (lateRegister && hasLocalSaved);

  document.getElementById('btnSave').disabled = isUserLocked;
  document.getElementById('miLocked').hidden = !isUserLocked;
  document.getElementById('miEdit').hidden = isUserLocked;

  if (isUserLocked) {
    if (locked) {
      document.getElementById('miLocked').innerHTML = '🔒 El torneo está cerrado: tu bracket quedó guardado y ya no se puede editar.';
    } else {
      document.getElementById('miLocked').innerHTML = '🔒 El torneo está en modo de registro tardío: tu bracket ya fue guardado y no se puede editar.';
    }
  }

  renderStage(editTarget, !isUserLocked);
  applyFit();
}

/* ---- Pestaña Tabla ---- */
async function showTabla(){
  const wrap = document.getElementById('tablaWrap');
  if(!sb){ wrap.innerHTML = msg('Configura Supabase para ver la tabla. (Modo local activo).'); return; }
  await loadSettings(); lockBadge();
  if(!settings.locked){ wrap.innerHTML = msg('La tabla se publica cuando el admin cierre el torneo.'); return; }
  wrap.innerHTML = msg('Cargando…');
  const [official, brackets] = await Promise.all([fetchOfficial(), fetchBrackets()]);
  const rows = brackets.map(b=>{
    const s = scoreBracket(b.picks?.winners, b.picks?.scores, official.winners, official.scores, settings.scoring);
    return { name:b.name, ...s };
  }).sort((x,y)=> y.total-x.total || y.hitsExact-x.hitsExact || y.hitsAdv-x.hitsAdv);
  if(!rows.length){ wrap.innerHTML = msg('Aún no hay brackets guardados.'); return; }
  wrap.innerHTML = `<table class="scoreboard">
    <thead><tr><th>#</th><th>Nombre</th><th>Total</th><th>Avance</th><th>Marcadores</th></tr></thead>
    <tbody>${rows.map((r,i)=>`<tr class="${i===0?'first':''}">
      <td>${i+1}</td><td>${escapeHtml(r.name)}</td><td class="pts">${r.total}</td>
      <td>${r.adv}</td><td>${r.sc} <span class="muted">(${r.hitsExact} exactos)</span></td></tr>`).join('')}</tbody>
  </table>`;
}

/* ---- Pestaña Brackets ---- */
let bracketsCache = [];
async function showBrackets(){
  const list = document.getElementById('bracketsList');
  moveStageTo('slot-mi');   // saca el bracket de aquí antes de reescribir el HTML
  if(!sb){ list.innerHTML = msg('Configura Supabase para ver los brackets del grupo.'); return; }
  await loadSettings(); lockBadge();
  if(!settings.locked){ list.innerHTML = msg('Los brackets de los demás se revelan cuando el admin cierre el torneo.'); return; }
  list.innerHTML = msg('Cargando…');
  bracketsCache = await fetchBrackets();
  if(!bracketsCache.length){ list.innerHTML = msg('Aún no hay brackets guardados.'); return; }
  list.innerHTML = `<div class="chips-row">${bracketsCache.map((b,i)=>
     `<button class="pcard" data-i="${i}">${escapeHtml(b.name)}</button>`).join('')}</div>
     <div id="viewerHost" class="stage-slot"></div>`;
  list.querySelectorAll('.pcard').forEach(btn=>btn.addEventListener('click',()=>{
    list.querySelectorAll('.pcard').forEach(x=>x.classList.remove('active'));
    btn.classList.add('active');
    viewBracket(bracketsCache[+btn.dataset.i]);
  }));
  viewBracket(bracketsCache[0]);
  list.querySelector('.pcard').classList.add('active');
}
function viewBracket(b){
  moveStageTo('viewerHost');
  const data = { W:{...DEFAULTS, ...(b.picks?.winners||{})}, S:(b.picks?.scores||{}) };
  renderStage(data, false);
  applyFit();
}

function msg(t){ return `<div class="bigmsg">${escapeHtml(t)}</div>`; }

/* ============================================================
   ADMIN
   ============================================================ */
async function renderAdmin(){
  const login = document.getElementById('adminLogin');
  const panel = document.getElementById('adminPanel');
  if(!sb){ login.innerHTML = msg('Configura Supabase (claves en app.js) para usar el panel de admin.'); panel.hidden=true; return; }
  const { data:{ session } } = await sb.auth.getSession();
  if(!session){ adminMode=false; login.hidden=false; panel.hidden=true; renderLoginForm(); return; }
  adminMode=true; login.hidden=true; panel.hidden=false;
  await loadSettings();
  // cargar oficial en offW/offS
  const off = await fetchOfficial();
  Object.assign(offW, DEFAULTS, off.winners||{});
  for(const k in offS) delete offS[k];
  Object.assign(offS, off.scores||{});
  editTarget = { W:offW, S:offS, kind:'official' };
  moveStageTo('slot-admin');
  renderStage(editTarget, true);
  document.getElementById('lockToggle').textContent = settings.locked ? 'Reabrir torneo' : 'Bloquear torneo';
  document.getElementById('adminLockState').textContent = settings.locked ? 'CERRADO' : 'ABIERTO';
  await renderEntries();
  applyFit();
}
function renderLoginForm(){
  document.getElementById('adminLogin').innerHTML = `
    <div class="admin-box">
      <h3>Admin</h3>
      <input id="admEmail" type="email" placeholder="email">
      <input id="admPass" type="password" placeholder="contraseña">
      <button id="admLoginBtn" class="primary">Entrar</button>
      <div id="admErr" class="status"></div>
    </div>`;
  document.getElementById('admLoginBtn').addEventListener('click', async ()=>{
    const email=document.getElementById('admEmail').value.trim();
    const password=document.getElementById('admPass').value;
    const { error } = await sb.auth.signInWithPassword({ email, password });
    if(error){ document.getElementById('admErr').textContent = error.message; return; }
    renderAdmin();
  });
}
async function adminSaveOfficial(){
  const st=document.getElementById('adminStatus'); st.textContent='Guardando oficiales…';
  const payload = { winners:advOnly(offW), scores:offS };
  const { error } = await sb.from('official').update({ picks:payload, updated_at:new Date().toISOString() }).eq('id',1);
  st.textContent = error ? ('Error: '+error.message) : 'Resultados oficiales guardados.';
}
async function adminToggleLock(){
  const next = !settings.locked;
  if(next && !confirm('¿Cerrar el torneo? Nadie podrá editar y se revelarán los brackets y la tabla.')) return;
  const late_register = next ? false : true;
  const { error } = await sb.from('settings').update({ locked:next, late_register_only:late_register, updated_at:new Date().toISOString() }).eq('id',1);
  if(error){ alert(error.message); return; }
  settings.locked = next;
  settings.late_register_only = late_register;
  lockBadge();
  document.getElementById('lockToggle').textContent = settings.locked ? 'Reabrir torneo' : 'Bloquear torneo';
  document.getElementById('adminLockState').textContent = settings.locked ? 'CERRADO' : 'ABIERTO';
}
async function renderEntries(){
  const box=document.getElementById('adminEntries');
  const list = await fetchBrackets();
  box.innerHTML = `<div class="entries-h">Participantes (${list.length})</div>` +
    list.map(b=>`<div class="entry"><span>${escapeHtml(b.name)}</span>
      <button class="del danger" data-id="${b.id}">Borrar</button></div>`).join('');
  box.querySelectorAll('.del').forEach(btn=>btn.addEventListener('click', async ()=>{
    if(!confirm('¿Borrar este bracket?')) return;
    const { error } = await sb.from('brackets').delete().eq('id', btn.dataset.id);
    if(error){ alert(error.message); return; }
    renderEntries();
  }));
}
async function adminLogout(){ await sb.auth.signOut(); adminMode=false; renderAdmin(); }

/* ============================================================
   AJUSTE A PANTALLA + EXPORT PNG + RESET
   ============================================================ */
let fitOn = true;
function applyFit(){
  const wrap = document.getElementById('stageWrap');
  const scroller = document.getElementById('scroller');
  if(!fitOn){ wrap.style.transform='none'; scroller.style.minHeight=''; return; }
  const top = scroller.getBoundingClientRect().top;
  const availH = Math.max(320, window.innerHeight - top - 16);
  const availW = window.innerWidth - 20;
  const scale = Math.min(1, availW/W, availH/STAGE_H);
  wrap.style.transform = `scale(${scale})`;
  scroller.style.minHeight = (STAGE_H*scale + 16)+'px';
}
window.addEventListener('resize', applyFit);

function loadScript(src){
  return new Promise((res,rej)=>{ const s=document.createElement('script'); s.src=src; s.onload=res; s.onerror=rej; document.head.appendChild(s); });
}
async function exportPNG(){
  const btn = document.getElementById('btnExport');
  const orig = btn.textContent; btn.textContent='Generando…'; btn.disabled=true;
  try{
    if(typeof html2canvas==='undefined'){
      await loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
    }
    const wrap = document.getElementById('stageWrap');
    const prev = wrap.style.transform;
    wrap.style.transform='none';
    await new Promise(r=>setTimeout(r,60));
    const canvas = await html2canvas(document.getElementById('stage'), {
      backgroundColor:'#060607', scale:2, useCORS:true, allowTaint:false,
      width:W, height:STAGE_H, windowWidth:W, windowHeight:STAGE_H
    });
    wrap.style.transform = prev;
    const a = document.createElement('a');
    a.download = 'bracket-mundial-26.png';
    a.href = canvas.toDataURL('image/png');
    a.click();
  }catch(err){
    alert('No se pudo exportar.\n'+err);
    document.getElementById('stageWrap').style.transform=''; applyFit();
  }finally{ btn.textContent=orig; btn.disabled=false; }
}

function resetMine(){
  if(!confirm('¿Borrar tus pronósticos? Los 16vos seguirán bloqueados con los mismos países.')) return;
  for(const k in state) delete state[k];
  Object.assign(state, DEFAULTS);
  for(const k in scores) delete scores[k];
  saveLocal();
  renderStage(editTarget, !settings.locked);
}

/* ============================================================
   INIT
   ============================================================ */
function wire(){
  document.querySelectorAll('#topnav [data-tab]').forEach(btn=>{
    btn.addEventListener('click', ()=>{ location.hash = '#' + btn.dataset.tab; });
  });
  document.getElementById('btnSave').addEventListener('click', submitMyBracket);
  document.getElementById('btnExport').addEventListener('click', exportPNG);
  document.getElementById('btnReset').addEventListener('click', resetMine);
  document.getElementById('btnFit').addEventListener('click', ()=>{ fitOn=!fitOn; applyFit(); });
  const ni=document.getElementById('nameInput');
  ni.addEventListener('input', e=>{ applyName(e.target.value); saveLocal(); });

  document.getElementById('btnSaveMatch').addEventListener('click', saveMatch);
  document.getElementById('btnClear').addEventListener('click', clearMatch);
  modalBg.addEventListener('click', e=>{ if(e.target===modalBg) closeModal(); });
  document.addEventListener('keydown', e=>{ if(e.key==='Escape') closeModal(); });

  document.getElementById('admSaveOfficial').addEventListener('click', adminSaveOfficial);
  document.getElementById('lockToggle').addEventListener('click', adminToggleLock);
  document.getElementById('admLogout').addEventListener('click', adminLogout);
}

async function init(){
  document.getElementById('stage').style.height = STAGE_H + 'px';
  drawBackground();
  drawConnectors();
  wire();
  loadLocal();
  await loadSettings();
  try {
    const off = await fetchOfficial();
    officialResults.winners = off.winners || {};
    officialResults.scores = off.scores || {};
  } catch(e) { console.warn('No se pudieron precargar resultados oficiales:', e); }
  lockBadge();
  if(!location.hash) location.hash = '#mi';
  route();
}
document.addEventListener('DOMContentLoaded', init);
