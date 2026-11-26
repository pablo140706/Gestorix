// ============================================================
//  CARRERA ACTIVA
// ============================================================
// `CARRERA`, `carreraActiva()` y `PLAN_ACTIVO` viven en data.js, que carga antes
// que este archivo. Aquí solo lo que se usa en tiempo de ejecución.

// Ofertas de la carrera activa. TODO lo que lea SCHEDULE debe pasar por aquí,
// o se cuelan las ofertas de las otras dos carreras.
function schedActual() {
  const sched = typeof SCHEDULE !== "undefined" ? SCHEDULE : [];
  return sched.filter((e) => e.carrera === CARRERA);
}

// ============================================================
//  PERSISTENCIA
// ============================================================
let memFallback = null;

// teacherMats ya no se usa (las materias de cada maestro salen de la base,
// ver MATS_DE_PROF); se conserva para no romper respaldos viejos.
// ingreso: periodo en que entraste ("25/1"); "" = no lo has dicho (bienvenida.js).
function blankState() {
  return { subjects: {}, horario: [], teacherMats: {}, ingreso: "" };
}

function load() {
  try {
    const raw = JSON.parse(localStorage.getItem(KEY));
    if (!raw) return blankState();
    return {
      subjects: raw.subjects || {},
      horario: raw.horario || [],
      teacherMats: raw.teacherMats || {},
      ingreso: raw.ingreso || "",
    };
  } catch (e) {
    return memFallback || blankState();
  }
}

function save() {
  try {
    localStorage.setItem(KEY, JSON.stringify(state));
  } catch (e) {
    memFallback = state;
  }
}

let state = load();

// ============================================================
//  HELPERS
// ============================================================
function idOf(s, i) { return "s" + s + "-" + i; }

function norm(s) {
  return String(s).toUpperCase()
    .normalize("NFD").replace(/[̀-ͯ]/g, "")
    .replace(/[^A-Z0-9 ]/g, " ")
    .replace(/\s+/g, " ").trim();
}

function esc(s) {
  return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;")
    .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

// ---- Cupos (ocupabilidad) — índice grupo+materia → {cupo, ins, disp} ----
// cupos.js llega diferido (ver lazy.js), así que los índices arrancan vacíos y
// se llenan cuando el archivo aterriza. Mientras tanto cupoDe() devuelve null y
// las etiquetas de cupo simplemente no se pintan.
const cuposIndex = {};
const cuposHistIndex = {};   // por periodo (CUPOS_HIST del cupos.js)

function indexarCupos() {
  if (typeof CUPOS !== "undefined" && Array.isArray(CUPOS)) {
    CUPOS.forEach((c) => { cuposIndex[c.g + "|" + norm(c.m)] = c; });
  }
  if (typeof CUPOS_HIST !== "undefined" && CUPOS_HIST) {
    Object.keys(CUPOS_HIST).forEach((p) => {
      cuposHistIndex[p] = {};
      (CUPOS_HIST[p] || []).forEach((c) => { cuposHistIndex[p][c.g + "|" + norm(c.m)] = c; });
    });
  }
}
indexarCupos();   // por si cupos.js se cargó antes (file:// o cache)

function cupoDe(grupo, materia) {
  if (!grupo || !materia) return null;
  return cuposIndex[grupo + "|" + norm(materia)] || null;
}
function cupoHistDe(grupo, materia, periodo) {
  const idx = cuposHistIndex[periodo];
  if (!idx || !grupo || !materia) return null;
  return idx[grupo + "|" + norm(materia)] || null;
}
// Etiqueta compacta "N/M" (inscritos/cupo) para un cupo histórico
function cupoHistTag(c) {
  if (!c) return "";
  const level = c.disp < 0 ? "full" : c.disp === 0 ? "full" : c.disp <= 5 ? "low" : "ok";
  return `<span class="cupo-tag" data-cupo="${level}" title="${c.ins} inscritos de ${c.cupo} · ${c.disp} disponibles">${c.ins}/${c.cupo}</span>`;
}
// Texto de disponibilidad: "12 lugares" / "1 lugar" / "Lleno" / "Sobrecupo".
function cupoDispTexto(d) {
  return d < 0 ? "Sobrecupo" : d === 0 ? "Lleno" : d + (d === 1 ? " lugar" : " lugares");
}
// Etiqueta "inscritos/cupo" (p. ej. "34/40") del periodo vigente, igual que la
// del historial, con color por disponibilidad y el detalle al pasar el mouse.
function cupoBadge(grupo, materia) {
  const c = cupoDe(grupo, materia);
  if (!c) return "";
  const d = c.disp;
  const level = d <= 0 ? "full" : d <= 5 ? "low" : "ok";
  const sobre = d <= 0 ? " · Sobrecupo: de 2 a 4 lugares más, en persona, con permiso del profe y de subdirección" : "";
  return `<span class="cupo-tag" data-cupo="${level}" title="${c.ins} inscritos de ${c.cupo} · ${cupoDispTexto(d)}${sobre}">${c.ins}/${c.cupo}</span>`;
}

// Cómo se reparten los lugares (docs/reglas-escolares.md).
const NOTA_CUPO = "Cupo = inscritos/lugares. Cada grupo abre 36: 30 para regulares, +4 para irregulares sin desfase " +
  "y +2 para quien trae desfase, dictamen o regresa de baja. Ya lleno, el sobrecupo da de 2 a 4 lugares más: " +
  "en persona, al regresar a clases (llega temprano a Gestión Escolar), con permiso del profe y de subdirección.";

// Status se DERIVA de calif (no se setea manualmente).
// pendiente = sin calif · aprobada = calif >= 6 · reprobada = calif < 6
function deriveStatus(calif) {
  if (calif === "" || calif == null) return "pendiente";
  const n = Number(calif);
  if (!Number.isFinite(n)) return "pendiente";
  return n >= 6 ? "aprobada" : "reprobada";
}

// ---------- periodos ----------
// "27/1" = ago–dic 2026 y "27/2" = ene–jun 2027. Para sumar se cuentan como
// números seguidos: 27/1 → 54, 27/2 → 55, 28/1 → 56…
function perANum(p) {
  const m = /^(\d{2})\/([12])$/.exec(p || "");
  return m ? Number(m[1]) * 2 + Number(m[2]) - 1 : null;
}
function numAPer(n) { return String(Math.floor(n / 2)).padStart(2, "0") + "/" + (n % 2 + 1); }
function perInicio(p) { const [a, n] = p.split("/").map(Number); return n === 1 ? "ago " + (2000 + a - 1) : "ene " + (2000 + a); }
function perFin(p) { const [a, n] = p.split("/").map(Number); return n === 1 ? "dic " + (2000 + a - 1) : "jun " + (2000 + a); }

// El periodo del IPN al que pertenece una fecha: ago–dic abre el /1 del año
// siguiente, enero todavía cuenta como ese /1 (ahí se cierran las actas, así
// que una calificación del 19 de enero de 2026 es del periodo 26/1) y feb–jul
// es el /2. Con el calendario cargado (calendario-ui.js) se usa el real.
function periodoDeFecha(f) {
  const d = f instanceof Date ? f : (f ? new Date(f) : null);   // new Date(null) sería 1970
  if (!d || isNaN(d.getTime())) return "";
  if (typeof calPeriodoDe === "function") {
    try {
      const p = calPeriodoDe(d);
      if (p && perANum(p.id) !== null) return p.id;
    } catch (e) { /* sin calendario */ }
  }
  const yy = d.getFullYear() % 100, mes = d.getMonth();
  if (mes >= 7) return numAPer((yy + 1) * 2);   // ago–dic: AA+1/1
  if (mes === 0) return numAPer(yy * 2);        // enero: todavía es AA/1
  return numAPer(yy * 2 + 1);                   // feb–jul: AA/2
}

// La fecha como la escribe SAES en el Kárdex: "19/01/2026", "19-ene-2026",
// "19 de enero de 2026". Devuelve Date, o null si no se entiende.
const MESES_ES = { ene: 0, feb: 1, mar: 2, abr: 3, may: 4, jun: 5, jul: 6, ago: 7, sep: 8, set: 8, oct: 9, nov: 10, dic: 11 };
function fechaDeSaes(txt) {
  const s = String(txt || "").toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "")
    .replace(/\bde\b/g, " ").replace(/\s+/g, " ").trim();
  const armar = (dia, mes, anio) => {
    const a = Number(anio) < 100 ? 2000 + Number(anio) : Number(anio);
    const d = new Date(a, mes, Number(dia));
    return isNaN(d.getTime()) || d.getMonth() !== mes ? null : d;
  };
  let m = /^(\d{1,2})[\/\-. ]+(\d{1,2})[\/\-. ]+(\d{2}|\d{4})$/.exec(s);
  if (m) return armar(m[1], Number(m[2]) - 1, m[3]);
  m = /^(\d{1,2})[\/\-. ]+([a-z]{3,})[\/\-. ]+(\d{2}|\d{4})$/.exec(s);
  if (m && MESES_ES[m[2].slice(0, 3)] !== undefined) return armar(m[1], MESES_ES[m[2].slice(0, 3)], m[3]);
  return null;
}

// El periodo en curso según el calendario del IPN (o el que sigue, si estás
// entre periodos). Antes de que cargue calendario-ui.js, o sin calendario, se
// deduce de la fecha.
let _periodoActual = null;
function periodoActual() {
  if (_periodoActual) return _periodoActual;
  const hoy = new Date(); hoy.setHours(0, 0, 0, 0);
  if (typeof calPeriodoDe === "function") {
    try {
      const p = calPeriodoDe(hoy) || calProximoPeriodo(hoy);
      if (p && perANum(p.id) !== null) return (_periodoActual = p.id);
    } catch (e) { /* sin calendario */ }
  }
  return periodoDeFecha(hoy);
}

// El más antiguo de dos periodos ("26/1" gana a "26/2"); ignora los vacíos.
function perMasAntiguo(a, b) {
  const na = perANum(a), nb = perANum(b);
  if (na === null) return nb === null ? "" : b;
  if (nb === null) return a;
  return na <= nb ? a : b;
}

// Un periodo nunca puede ser anterior a tu ingreso: si no estabas inscrito, no
// pudiste cursar nada (usuario, 2026-11-25). Devuelve el periodo acotado.
function perDesdeIngreso(p, ingreso) {
  const n = perANum(p), ing = perANum(ingreso);
  if (n === null || ing === null) return p || "";
  return n < ing ? ingreso : p;
}

// Desfase (docs/reglas-escolares.md; usuario, 2026-11-21). Se cuenta desde el
// periodo P en que reprobaste el ORDINARIO (1.ª vez), aunque luego recursaras:
//   P+1      → a tiempo (recurse o ETS)
//   P+2      → "ultimo": el 3.er semestre, ahí debes pasarla (por ETS si ya
//              reprobaste el recurse)
//   P+3      → "carta24": desfasada; te reinscribes con carta de 24 créditos
//   P+4 o más→ "dictamen": 4 semestres sin pasarla; solo tienes derecho a ETS
//              y no puedes inscribir nada hasta pasarlo
function desfaseDe(perRep) {
  const p = perANum(perRep);
  if (p === null) return "";
  const d = perANum(periodoActual()) - p;
  return d >= 4 ? "dictamen" : d === 3 ? "carta24" : d === 2 ? "ultimo" : "";
}
function esDesfasada(desf) { return desf === "carta24" || desf === "dictamen"; }

// Textos de cada nivel, para la fila, los avisos y la ventana de reprobadas.
const TEXTO_DESFASE = {
  ultimo: "Este es tu 3.er semestre desde que la reprobaste: tienes que pasarla ahora (por ETS si ya reprobaste el recurse); si no, se desfasa.",
  carta24: "Desfasada: no la pasaste en 3 semestres. Te reinscribes con carta de 24 créditos (menos materias) y te comprometes a pasarla por ETS.",
  dictamen: "Dictamen: 4 semestres sin pasarla. Solo tienes derecho a ETS y no puedes inscribir nada hasta pasarlo.",
};

// Estado de una materia (CLAUDE.md §4.2). `status` es uno de los tres de
// siempre (pendiente / aprobada / reprobada); el ETS se marca aparte:
//   porEts  → reprobó el curso pero aprobó el ETS: cuenta como aprobada
//   soloEts → reprobó el recurse: ya no se puede cursar, solo presentar ETS
// Sin número (privacidad, 2026-11-21): `res` ("aprobada"/"reprobada") vale
// cuando no hay calificación, y `res_ets` ("aprobado"/"reprobado") cuando no
// hay calificación de ETS. Cuentan para el estado, no para el promedio.
function getSub(id, defName) {
  const r = state.subjects[id] || {};
  const calif = r.calif || "";
  const calif_ets = r.calif_ets || "";
  const res = calif === "" ? (r.res || "") : "";
  const res_ets = calif_ets === "" ? (r.res_ets || "") : "";
  const veces = Number(r.veces || 1);
  const delCurso = calif !== "" ? deriveStatus(calif) : (res || "pendiente");
  const etsAprobado = calif_ets !== "" ? Number(calif_ets) >= 6 : res_ets === "aprobado";
  const porEts = delCurso === "reprobada" && etsAprobado;
  // Periodo en que la reprobaste y desfase: solo mientras la debas. Si lo
  // guardado quedó antes de tu ingreso (datos de antes de la regla, o un
  // ingreso corregido después), se acota a tu ingreso.
  const per_rep = delCurso === "reprobada" ? perDesdeIngreso(r.per_rep || "", state.ingreso) : "";
  // Proyecto (TT I, TT II, Estancia) que el alumno marcó que está llevando.
  // Al aprobarlo deja de contar solo, sin que tenga que desmarcarlo.
  const proy = esProyecto(id) && delCurso !== "aprobada" && !porEts && !!r.proy;
  return {
    calif,
    calif_ets,
    res,
    res_ets,
    per_rep,
    proy,
    veces,
    status: porEts ? "aprobada" : delCurso,
    reproboCurso: delCurso === "reprobada",
    porEts,
    soloEts: delCurso === "reprobada" && !porEts && veces >= 2,
    desfase: delCurso === "reprobada" && !porEts ? desfaseDe(per_rep) : "",
    name: r.name || defName,
  };
}

// La calificación que entra al promedio: la MÁS ALTA con número de cada
// materia, aprobada o reprobada (usuario, 2026-11-25; antes la última, es
// decir la del ETS si lo presentaste —2026-11-21—, y antes de eso solo las
// aprobadas). Un ETS reprobado más bajo que el ordinario ya no baja tu
// promedio, y si el ETS se marcó sin número tampoco borra la del curso.
// Sin ningún número (privacidad) no entra: no hay número que promediar.
function califParaPromedio(rec) {
  let alta = null;
  if (rec.calif !== "") alta = Number(rec.calif);
  if (rec.calif_ets !== "") alta = alta === null ? Number(rec.calif_ets) : Math.max(alta, Number(rec.calif_ets));
  return alta;
}

function setSub(id, patch) {
  const cur = state.subjects[id] || {};
  state.subjects[id] = Object.assign({}, cur, patch);
  save();
}

// ¿La materia puede inscribirse al horario? No si está aprobada (por curso o
// por ETS), ni si ya solo puede ir por ETS (reprobó el recurse).
function canInscribir(rec) {
  if (rec.status === "aprobada") return false;
  if (rec.soloEts) return false;
  return true;
}

// TODAS las reprobadas (1.ª vez o recurse, también las de solo por ETS)
// ocupan carga hasta que las apruebes, aunque no estén en el horario (usuario,
// 2026-11-21; antes solo las de solo por ETS). Si ya está en el horario, ahí
// se cuenta y aquí no, para no contarla dos veces.
function materiasSoloEts() {
  const res = [];
  for (let s = 0; s < PLAN.length; s++) {
    PLAN[s].materias.forEach(([name, cred], i) => {
      const id = idOf(s, i);
      const rec = getSub(id, name);
      if (rec.status === "reprobada" && !estaInscrita(id)) res.push({ id, name: rec.name, cred, ua: uaDe(id), sem: s + 1 });
    });
  }
  return res;
}

// Regular: no debes nada de semestres anteriores (ni reprobadas ni materias
// sin cursar por debajo de lo más alto que ya aprobaste). Solo los regulares
// pueden meter la carga máxima; los irregulares, hasta la media (usuario,
// 2026-11-21). Los lugares de optativa no cuentan (pueden no estar elegidos).
function esRegular() {
  let maxAprob = 0;
  PLAN.forEach((blk, s) => blk.materias.forEach(([name], i) => {
    if (getSub(idOf(s, i), name).status === "aprobada") maxAprob = Math.max(maxAprob, s + 1);
  }));
  for (let s = 0; s < PLAN.length; s++) {
    for (let i = 0; i < PLAN[s].materias.length; i++) {
      const id = idOf(s, i);
      const r = getSub(id, PLAN[s].materias[i][0]);
      if (r.status === "reprobada") return false;
      if (s + 1 < maxAprob && r.status !== "aprobada" && !OPT_SLOTS[id]) return false;
    }
  }
  return true;
}
function cargaMaxPermitida() { return esRegular() ? CARGA.max : CARGA.media; }

// Ventana de inscripción (regla fundamental, usuario 2026-11-21): solo puedes
// inscribir materias de 3 semestres seguidos, contando desde el más bajo en el
// que debes algo. Debes de 1.º → de 1.º a 3.º; lo más bajo que debes es de
// 2.º → de 2.º a 4.º. null = ya no debes nada.
function ventanaInscripcion() {
  for (let s = 0; s < PLAN.length; s++) {
    const debe = PLAN[s].materias.some(([name], i) => getSub(idOf(s, i), name).status !== "aprobada");
    if (debe) return { lo: s + 1, hi: Math.min(PLAN.length, s + 3) };
  }
  return null;
}
function creditosBloqueados() { return materiasSoloEts().reduce((a, m) => a + m.cred, 0); }
function uaBloqueadas() { return materiasSoloEts().reduce((a, m) => a + m.ua, 0); }

// Los proyectos que marcaste que estás llevando (TT I, TT II, Estancia). No
// están en el horario —no tienen oferta ni hora— pero sí ocupan carga: TT vale
// 2 UA y la Estancia 1 (usuario, 2026-11-25).
function proyectosEnCurso() {
  const res = [];
  PLAN.forEach((blk, s) => {
    blk.materias.forEach(([name, cred], i) => {
      const id = idOf(s, i);
      if (!esProyecto(id)) return;
      const rec = getSub(id, name);
      if (rec.proy) res.push({ id, name: rec.name || name, cred, ua: uaDe(id), sem: s + 1 });
    });
  });
  return res;
}
function uaProyectos() { return proyectosEnCurso().reduce((a, p) => a + p.ua, 0); }

// Texto del badge de estado
function statusBadgeText(rec, inscrita) {
  if (rec.status === "aprobada") {
    if (rec.porEts) return "Aprobada por ETS";
    return rec.veces === 2 ? "Aprobada (recurse)" : "Aprobada";
  }
  if (rec.status === "reprobada") {
    if (rec.desfase === "dictamen") return "⛔ Dictamen · solo ETS";
    if (rec.desfase === "carta24") return rec.soloEts ? "⚠️ Desfasada · carta 24 cr · ETS" : "⚠️ Desfasada · carta 24 cr";
    return rec.soloEts ? "🔒 Solo por ETS" : "Reprobada · recurse o ETS";
  }
  // pendiente: si ya está en el horario, mostrar "Inscrita"
  if (rec.proy) return "🧩 Lo estás llevando";          // proyecto: no va en el horario
  if (inscrita) return rec.veces >= 2 ? "🔁 Inscrita (recurse)" : "Inscrita";
  // pendiente sin inscribir: distingue 1ª vez de recurse en curso (2ª vez sin calif)
  return rec.veces >= 2 ? "🔁 En recurse" : "Pendiente";
}
// ¿La materia está en recurse en curso? (2ª vez, aún sin calificar)
function esEnRecurse(rec) {
  return rec.status === "pendiente" && rec.veces >= 2;
}
// ¿La materia (por id) está inscrita en el horario?
function estaInscrita(id) {
  return state.horario.some((h) => h.sid === id);
}

// Fuentes/métricas manuales de maestros (ganan sobre TEACHER_METRICS; si falta, cae al seed).
// Se llenan desde MANUAL_LINKS (maestros_manual.js) al cargar la página.
const MANUAL_METRICS = {};      // nombre exacto → {calidad, recomiendan, dificultad, link}
const MANUAL_METRICS_NORM = {}; // norm(nombre) → mismo objeto (fallback por normalización)

function manualMetricFor(name) {
  return MANUAL_METRICS[name] || MANUAL_METRICS_NORM[norm(name)] || null;
}

function getMetric(name) {
  // El manual (maestros_manual.js) gana; si falta un campo, cae al seed de metrics.js.
  const man = manualMetricFor(name) || {};
  const seed = TEACHER_METRICS_NORM[norm(name)] || {};
  const pick = (k) =>
    man[k] !== undefined && man[k] !== null && man[k] !== "" ? man[k]
    : seed[k] !== undefined && seed[k] !== null && seed[k] !== "" ? seed[k]
    : "";
  return { calidad: pick("calidad"), recomiendan: pick("recomiendan"), dificultad: pick("dificultad") };
}

// Registra un override manual; mergea si ya existía (gana lo que traiga dato)
function registerManual(name, obj) {
  if (obj.calidad === "" && obj.recomiendan === "" && obj.dificultad === "" && !obj.link) return;
  const prev = MANUAL_METRICS[name] || {};
  const merged = {
    calidad:     obj.calidad     !== "" ? obj.calidad     : (prev.calidad ?? ""),
    recomiendan: obj.recomiendan !== "" ? obj.recomiendan : (prev.recomiendan ?? ""),
    dificultad:  obj.dificultad  !== "" ? obj.dificultad  : (prev.dificultad ?? ""),
    link:        obj.link || prev.link || "",
  };
  MANUAL_METRICS[name] = merged;
  MANUAL_METRICS_NORM[norm(name)] = merged;
}

function refreshAfterManual() {
  repintarActiva();   // lazy.js — cubre las 6 pestañas y la ficha del maestro
}

function loadManualMetrics() {
  // Fuente: maestros_manual.js (cargado con <script>). Funciona también sin
  // servidor (file://). Para actualizar: edita maestros_manual.csv y corre build.ps1.
  if (typeof MANUAL_LINKS === "undefined" || !MANUAL_LINKS) return;
  Object.keys(MANUAL_LINKS).forEach((name) => {
    const v = MANUAL_LINKS[name];
    const link = typeof v === "string" ? v : (v && v.link) || "";
    const cal  = (v && v.calidad     != null) ? v.calidad     : "";
    const rec  = (v && v.recomiendan != null) ? v.recomiendan : "";
    const dif  = (v && v.dificultad  != null) ? v.dificultad  : "";
    registerManual(name, { calidad: cal, recomiendan: rec, dificultad: dif, link });
  });
  refreshAfterManual();
}

// Nombre legible de la materia para un slot (incluye optativa elegida)
function subjectName(s, i) {
  const id = idOf(s, i);
  const def = PLAN[s].materias[i][0];
  if (OPT_SLOTS[id]) return getSub(id, def).name;
  return def;
}

// Ofertas reales (SCHEDULE) que aplican a un slot del plan. Con conEquiv
// (por omisión), también los grupos de su materia EQUIVALENTE en IA o LCD
// (o ISC): se pueden inscribir, pero solo a mano (el automático no los usa).
function scheduleFor(s, i, conEquiv = true) {
  const propias = scheduleForPropias(s, i);
  const clave = CLAVE_DE_ID[idOf(s, i)];
  if (!conEquiv || !clave || !EQUIV[clave] || typeof SCHEDULE === "undefined") return propias;
  const otras = new Set(EQUIV[clave]);
  return propias.concat(SCHEDULE.filter((e) => e.carrera !== CARRERA && otras.has(e.clave)));
}
function scheduleForPropias(s, i) {
  const id = idOf(s, i);
  const slot = OPT_SLOTS[id];
  const sched = schedActual();
  if (slot) {
    // El slot acepta cualquier optativa de su semestre que ESCOM haya abierto
    // este periodo, en las tres carreras. (En ISC antes había un filtro A =
    // matutino / B = vespertino sacado del roster del Excel; esa división se
    // abandonó y el roster ya no la trae.)
    const nombres = new Set(
      PLAN_ACTIVO.optativas.filter((o) => o.sem === slot.sem).map((o) => norm(o.saes))
    );
    const sc = String(slot.sem);
    return sched.filter((e) => e.grupo.startsWith(sc) && nombres.has(norm(e.materia)));
  }
  const def = PLAN[s].materias[i][0];
  const k = norm(def);
  return sched.filter((e) => norm(e.materia) === k);
}

function sesionesText(sesiones) {
  if (!sesiones || sesiones.length === 0) return "";
  return sesiones.map((s) => `${s.dia} ${s.ini}-${s.fin}`).join(" · ");
}

// Conflictos entre dos items con sesiones
function sessionsOverlap(a, b) {
  if (a.dia !== b.dia) return false;
  return a.ini < b.fin && b.ini < a.fin;
}
function itemsConflict(a, b) {
  if (!a.sesiones || !b.sesiones) return false;
  for (const sa of a.sesiones) for (const sb of b.sesiones) {
    if (sessionsOverlap(sa, sb)) return true;
  }
  return false;
}

// Lista única de maestros (para la pestaña Maestros)
// `schedule.js` guarda los nombres normalizados (sin acentos) y `metrics.js`,
// `roster.js` y `maestros_manual.csv` los conservan. Sin estos dos índices, el
// mismo profe sale dos veces en la lista y pierde su métrica.
const TEACHER_METRICS_NORM = (() => {
  const m = {};
  if (typeof TEACHER_METRICS !== "undefined") {
    Object.keys(TEACHER_METRICS).forEach((k) => { m[norm(k)] = TEACHER_METRICS[k]; });
  }
  return m;
})();

// Nombre para mostrar: gana el que traiga acentos.
const NOMBRE_PROF = (() => {
  const m = new Map();
  const put = (n) => {
    if (!n) return;
    const k = norm(n);
    if (!m.has(k) || n !== k) m.set(k, n);
  };
  if (typeof TEACHER_METRICS !== "undefined") Object.keys(TEACHER_METRICS).forEach(put);
  if (typeof ROSTER !== "undefined") ROSTER.forEach((e) => put(e.t));
  return m;
})();
function nombreProf(n) { return NOMBRE_PROF.get(norm(n)) || n; }

function allTeachers() {
  // Índice rápido: materia → primer índice de semestre del plan
  const matToSem = new Map();
  PLAN.forEach((blk, sIdx) => blk.materias.forEach(([mat]) => {
    const k = norm(mat);
    if (!matToSem.has(k)) matToSem.set(k, sIdx + 1);
  }));

  const map = {};
  // Indexado por nombre normalizado para que "MOLINA PÉREZ" y "MOLINA PEREZ"
  // sean el mismo maestro.
  const add = (nombre) => {
    const k = norm(nombre);
    if (!map[k]) map[k] = { name: nombreProf(nombre), materias: new Set(), grupos: new Set(), semestres: new Set() };
    return map[k];
  };

  // Fuente principal: las ofertas reales de LAS TRES carreras. La lista de
  // maestros no se separa por carrera (las métricas son globales); el selector
  // de carrera manda sobre el plan y el horario, no sobre quién aparece aquí.
  const ofertas = typeof SCHEDULE !== "undefined" ? SCHEDULE : [];
  ofertas.forEach((o) => {
    if (!o.profesor) return;
    const t = add(o.profesor);
    t.materias.add(o.materia);
    if (o.grupo) { t.grupos.add(o.grupo); t.semestres.add(parseInt(o.grupo[0])); }
  });

  // ROSTER (api/roster.php): las materias que cada profe dio en periodos pasados y
  // este ya no. Así salen también los profes que este periodo no dan clase.
  ROSTER.forEach((e) => {
    const t = add(e.t);
    t.materias.add(e.m);
    // Extraer grupos del campo g (ej: "1CM1, 1CM5" o "6CM3 (Big Data)")
    (e.g || "").split(",").forEach((gp) => {
      const m = gp.trim().match(/^[1-8][A-Z]{2}\d+/);
      if (m) { t.grupos.add(m[0]); t.semestres.add(parseInt(m[0][0])); }
    });
    const semFromMat = matToSem.get(norm(e.m));
    if (semFromMat) t.semestres.add(semFromMat);
    // Para optativas, derivar semestre del slot (A1/B1 → 6, A2/B2 → 7)
    const optMatch = e.m.match(/OPTATIVA\s+([AB])([12])/);
    if (optMatch) t.semestres.add(optMatch[2] === "1" ? 6 : 7);
  });

  return Object.values(map).map((x) => ({
    name: x.name,
    materias: [...x.materias],
    grupos: [...x.grupos].sort(),
    semestres: [...x.semestres].sort((a, b) => a - b),
  }));
}
const TEACHERS = allTeachers();

// En qué carreras da clase cada profe (las métricas son globales, un profe se
// comparte entre carreras).
const CARRERAS_DE_PROF = (() => {
  const m = new Map();
  (typeof SCHEDULE !== "undefined" ? SCHEDULE : []).forEach((o) => {
    if (!o.profesor) return;
    const k = norm(o.profesor);
    if (!m.has(k)) m.set(k, new Set());
    m.get(k).add(o.carrera);
  });
  return m;
})();

function carreraBadges(name) {
  const set = CARRERAS_DE_PROF.get(norm(name));
  if (!set || set.size === 0) return "";
  return [...set].sort().map((c) =>
    `<span class="cbadge c-${c.toLowerCase()}${c === CARRERA ? " propia" : ""}" title="${c}">${c}</span>`
  ).join("");
}

// Turno (M/V) a partir del código de grupo. 3.er char: M=matutino, V=vespertino.
function turnoDeGrupo(g) {
  const m = String(g).trim().match(/^[1-8][A-Z]([MV])/);
  return m ? m[1] : null;
}

// Carrera codificada en la 2.ª letra del grupo: C=ISC, B=IA, A=LCD.
// Es un RESPALDO, no la fuente: las ofertas traen campo `carrera` explícito
// (CLAUDE.md §9) y hay que usar ese. Esto solo sirve para datos viejos que
// todavía no lo tengan.
const LETRA_CARRERA = { C: "ISC", B: "IA", A: "LCD" };

// Grupos de recurse (irregulares), solo en 1.er semestre (usuario, 2026-11-21):
// en la mañana del 7 en adelante (1CM1–6 son regulares) y en la tarde del 6 en
// adelante (1CV1–5 son regulares). En los demás semestres no hay.
function esGrupoRecurse(g) {
  const m = /^1[ABC]([MV])(\d+)$/.exec(g || "");
  return !!m && Number(m[2]) >= (m[1] === "V" ? 6 : 7);
}
function carreraDeGrupo(g) {
  const m = String(g).trim().match(/^[1-8]([A-Z])[MV]/);
  return m ? (LETRA_CARRERA[m[1]] || null) : null;
}

// La carrera de una oferta: el campo si lo trae, y si no, deducida del grupo
function carreraDeOferta(o) {
  return o.carrera || carreraDeGrupo(o.grupo);
}
function turnosDeGrupos(grupos) {
  const set = new Set();
  (grupos || []).forEach((g) => { const t = turnoDeGrupo(g); if (t) set.add(t); });
  return set;
}
function turnoBadges(grupos) {
  const set = turnosDeGrupos(grupos);
  let html = "";
  if (set.has("M")) html += `<span class="tbadge tm" title="Matutino">M</span>`;
  if (set.has("V")) html += `<span class="tbadge tv" title="Vespertino">V</span>`;
  return html;
}

function titleCase(s) {
  return String(s).toLowerCase().replace(/(^|\s|\()([a-záéíóúñ])/g, (m) => m.toUpperCase());
}

// Materias de cada maestro y si las da este periodo. Sale de la base, nadie
// lo edita:
//   · active: true  → tiene oferta de esa materia en el periodo vigente
//                     (api/horarios.php, las tres carreras);
//   · active: false → la dio en un periodo pasado y este ya no
//                     (api/roster.php); periodo = el último en que la dio.
// Antes era una nota manual guardada en el navegador (state.teacherMats) y
// todo arrancaba en verde, aunque el profe ya no diera la materia.
const MATS_DE_PROF = (() => {
  const m = new Map();                       // nombre normalizado → Map(materia normalizada → {…})
  const de = (nombre) => {
    const k = norm(nombre);
    if (!m.has(k)) m.set(k, new Map());
    return m.get(k);
  };
  (typeof SCHEDULE !== "undefined" ? SCHEDULE : []).forEach((o) => {
    if (o.profesor) de(o.profesor).set(norm(o.materia), { mat: o.materia, active: true, periodo: null });
  });
  (typeof ROSTER !== "undefined" ? ROSTER : []).forEach((e) => {
    const mats = de(e.t);
    if (!mats.has(norm(e.m))) mats.set(norm(e.m), { mat: e.m, active: false, periodo: e.p || null });
  });
  return m;
})();

// Las que da primero, luego las que ya no; dentro de cada grupo, por nombre.
function teacherMaterias(name) {
  const mats = MATS_DE_PROF.get(norm(name));
  if (!mats) return [];
  return [...mats.values()].sort((a, b) => (b.active - a.active) || a.mat.localeCompare(b.mat));
}

