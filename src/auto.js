// ============================================================
//  P17 · MODO AUTOMÁTICO
// ============================================================
// Antes había pestañas Manual / Automático; la de Manual no mostraba nada.
// Ahora el automático es una sola barra siempre visible (index.html).

function hhmmToMin(t) { const [h, m] = t.split(":").map(Number); return h * 60 + m; }

function ofertaCaeEnVentana(sesiones, iniMin, finMin) {
  return sesiones.every((s) => hhmmToMin(s.ini) >= iniMin && hhmmToMin(s.fin) <= finMin);
}

// Detecta conflicto entre dos arrays de sesiones
function sesionesChocan(a, b) {
  for (const sa of a) for (const sb of b) {
    if (sa.dia === sb.dia && sa.ini < sb.fin && sb.ini < sa.fin) return true;
  }
  return false;
}

// Bloques de clase (horas de inicio). El índice mide huecos en la rejilla.
const BLOQUE_INI = ["07:00","08:30","10:30","12:00","13:30","15:00","16:30","18:30","20:00"];
function bloqueIdx(ini) {
  const i = BLOQUE_INI.indexOf(ini);
  if (i !== -1) return i;
  const min = hhmmToMin(ini); let best = 0;
  BLOQUE_INI.forEach((b, k) => { if (hhmmToMin(b) <= min) best = k; });
  return best;
}
// Horas muertas: bloques vacíos entre la 1.ª y la última clase de cada día
function contarHuecos(items) {
  const byDay = {};
  items.forEach((it) => (it.sesiones || []).forEach((s) => {
    (byDay[s.dia] = byDay[s.dia] || []).push(bloqueIdx(s.ini));
  }));
  let huecos = 0;
  Object.values(byDay).forEach((idxs) => {
    idxs.sort((a, b) => a - b);
    huecos += (idxs[idxs.length - 1] - idxs[0] + 1) - idxs.length;
  });
  return huecos;
}
function shuffle(arr) {
  const a = arr.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
// ============================================================
//  SERIACIÓN
// ============================================================
// Viene de api/planes.php como PLAN_ACTIVO.seriacion, con clave → [claves].
// Una materia SOLO entra en modo Auto si TODOS sus prerrequisitos están
// APROBADOS (si alguno está reprobado o pendiente, se bloquea).
//
// ISC sale de las flechas del mapa oficial. IA y LCD no tienen seriación
// oficial (sus mapas no dibujan flechas): lo que hay es una propuesta por
// nombres que el usuario aprobó. Ver CLAUDE.md §9.
const VENTANA_SEM = 3; // máximo de semestres que puede abarcar el horario auto

// Materia del plan a partir de su clave oficial
function materiaPorClave(clave) {
  const id = ID_DE_CLAVE[clave];
  if (!id) return null;
  const m = id.match(/^s(\d+)-(\d+)$/);
  if (!m) return null;
  const s = +m[1], i = +m[2];
  const entry = PLAN[s] && PLAN[s].materias[i];
  if (!entry) return null;
  return { s, i, id, name: entry[0] };
}

// Prerrequisitos pendientes de una materia del plan, por su id (s{sem}-{i})
function prereqsFaltantesDe(id) {
  const clave = CLAVE_DE_ID[id];
  if (!clave) return [];
  const reqs = (PLAN_ACTIVO.seriacion || {})[clave];
  if (!reqs || !reqs.length) return [];
  return reqs
    .map(materiaPorClave)
    .filter((mt) => mt && getSub(mt.id, mt.name).status !== "aprobada");
}

function prereqsAprobados(id) { return prereqsFaltantesDe(id).length === 0; }

// Nombre legible del primer prereq que falta (para el mensaje)
function prereqFaltante(id) {
  const f = prereqsFaltantesDe(id);
  return f.length ? f[0].name : null;
}

// Ajusta la ventana horaria sugerida según el turno elegido
document.getElementById("autoTurno").addEventListener("change", (e) => {
  const v = e.target.value;
  const ent = document.getElementById("autoEntrada");
  const sal = document.getElementById("autoSalida");
  if (v === "M") { ent.value = "07:00"; sal.value = "15:00"; }
  else if (v === "V") { ent.value = "12:00"; sal.value = "21:30"; }
  else { ent.value = "07:00"; sal.value = "21:30"; }
});

// Estado del generador (para el botón "Otra opción")
let autoPool = [];        // soluciones distintas, todas con el máximo de materias colocadas
let autoLastKey = null;   // última combinación mostrada (para no repetir)
let autoCtx = null;       // { semNombre, totalFaltantes }

function keyDeSol(sol) { return sol.elegidas.map((e) => e.sid + ":" + e.grupo).sort().join("|"); }

function generarHorarioAuto() {
  const entrada = document.getElementById("autoEntrada").value;
  const salida = document.getElementById("autoSalida").value;
  const turno = document.getElementById("autoTurno").value;
  const maxMat = Math.max(1, Math.min(9, parseInt(document.getElementById("autoMax").value) || 7));
  const conEquiv = !!document.getElementById("autoEquiv")?.checked;
  const resultEl = document.getElementById("autoResult");
  const otraBtn = document.getElementById("autoOtraBtn");

  if (!entrada || !salida) { alert("Captura hora de entrada y salida."); return; }
  const iniMin = hhmmToMin(entrada);
  const finMin = hhmmToMin(salida);
  if (iniMin >= finMin) { alert("La hora de salida debe ser mayor que la de entrada."); return; }

  const base = state.horario.filter((h) => !h._auto);
  // Carga en UA: el automático llena hasta la carga MEDIA (pasarla requiere
  // trámite; eso lo decide el alumno a mano). Las reprobadas ya ocupan carga
  // aunque no estén en el horario (core.js); si el automático mete una, se
  // cuenta como colocada y no dos veces (ver uaDisponibles más abajo).
  const uaBloq = uaBloqueadas();
  const uaBase = base.reduce((a, h) => a + uaDe(h.sid), 0);

  // 1) Todas las pendientes inscribibles que no estén ya en el horario, más
  //    las reprobadas que todavía se pueden recursar. Esas (y las que ya van
  //    en recurse) tienen PRIORIDAD (usuario, 2026-11-21).
  const pendientes = [];
  for (let s = 0; s < PLAN.length; s++) {
    PLAN[s].materias.forEach(([name, cred], i) => {
      const id = idOf(s, i);
      if (OPT_SLOTS[id]) return;
      if (esProyecto(id)) return;   // TT y Estancia no tienen oferta que colocar
      const rec = getSub(id, name);
      const aRecursar = rec.status === "reprobada" && canInscribir(rec);   // no "solo por ETS"
      if ((rec.status === "pendiente" || aRecursar) && canInscribir(rec) && !base.some((h) => h.sid === id)) {
        const recurse = aRecursar || rec.veces >= 2;
        pendientes.push({ id, name, cred, ua: uaDe(id), i, s, recurse, prioridad: recurse, reprobada: aRecursar });
      }
    });
  }
  // Las reprobadas que el automático puede meter ya vienen dentro de uaBloq:
  // se quitan de ahí para que, al colocarlas, cuenten una sola vez.
  const uaReprobColocables = pendientes.filter((f) => f.reprobada).reduce((a, f) => a + f.ua, 0);
  // Los proyectos marcados (TT, Estancia) ocupan carga y no se pueden colocar:
  // se descuentan igual que las reprobadas fijas (usuario, 2026-11-25).
  const uaFijas = uaBloq - uaReprobColocables + uaProyectos();
  const uaDisponibles = CARGA.media - uaFijas - uaBase;

  if (pendientes.length === 0) {
    autoPool = []; autoLastKey = null; autoCtx = null;
    if (otraBtn) otraBtn.hidden = true;
    resultEl.innerHTML = `<div class="auto-warn">No faltan materias por inscribir (o ya las tienes en el horario).</div>`;
    return;
  }

  // 2) Seriación: la dependiente solo entra si su prerequisito está aprobado
  const bloqueadasSer = pendientes.filter((f) => !prereqsAprobados(f.id));
  let faltantes = pendientes.filter((f) => prereqsAprobados(f.id));

  if (faltantes.length === 0) {
    autoPool = []; autoLastKey = null; autoCtx = null;
    if (otraBtn) otraBtn.hidden = true;
    const ejemplo = bloqueadasSer[0];
    const req = ejemplo ? prereqFaltante(ejemplo.id) : null;
    resultEl.innerHTML = `<div class="auto-warn">Todas las pendientes están bloqueadas por seriación` +
      (req ? ` (ej.: <b>${esc(ejemplo.name)}</b> necesita aprobar <b>${esc(req)}</b>)` : "") +
      `. Aprueba/captura los prerequisitos primero o agrégalas a mano.</div>`;
    return;
  }

  // 3) Ventana de semestres: ancla en el semestre más bajo con pendientes
  //    colocables y permite a lo más VENTANA_SEM semestres (ej. 1 → 1,2,3).
  // La ventana se ancla en lo más bajo que DEBES (aunque sea solo por ETS),
  // no solo en lo que se puede colocar (ventanaInscripcion, core.js).
  const ventana = ventanaInscripcion();
  const minSem = ventana ? ventana.lo - 1 : Math.min(...faltantes.map((f) => f.s));
  const maxSem = minSem + (VENTANA_SEM - 1);
  const fueraVentana = faltantes.filter((f) => f.s > maxSem);
  faltantes = faltantes.filter((f) => f.s <= maxSem);

  if (uaDisponibles <= 0) {
    autoPool = []; if (otraBtn) otraBtn.hidden = true;
    resultEl.innerHTML = `<div class="auto-warn">Ya llegaste a la carga media: ${uaBase} UA inscritas` +
      (uaFijas ? ` + ${uaFijas} de reprobadas y proyectos` : "") + ` = ${uaBase + uaFijas} de ${CARGA.media}. ` +
      (esRegular() ? `Para pasar de la media (hasta ${CARGA.max}, con trámite) agrega materias a mano.` : `Como debes materias, tu máximo es la media.`) + `</div>`;
    return;
  }

  const addMax = Math.max(0, maxMat - base.length);
  if (addMax === 0) {
    if (otraBtn) otraBtn.hidden = true;
    resultEl.innerHTML = `<div class="auto-warn">Ya tienes ${base.length} materias en el horario (tu tope es ${maxMat}). Sube el tope para agregar más.</div>`;
    return;
  }

  const cand = faltantes.map((f) => {
    // Equivalentes de otras carreras solo si marcaste "Equivalencias".
    const ofs = scheduleFor(f.s, f.i, conEquiv)
      .filter((e) => turno === "ambos" || (turnoDeGrupo(e.grupo) || "M") === turno)
      .filter((e) => ofertaCaeEnVentana(e.sesiones, iniMin, finMin))
      .filter((e) => !base.some((h) => sesionesChocan(h.sesiones, e.sesiones)))
      // 1.er semestre: el recurse solo en grupos de recurse (7+), lo nuevo solo
      // en regulares (1–6). Los demás semestres no tienen grupos de recurse.
      .filter((e) => f.s !== 0 || (f.recurse ? esGrupoRecurse(e.grupo) : !esGrupoRecurse(e.grupo)));
    return { ...f, ofs };
  });

  const prioridad = cand.filter((f) => f.prioridad);
  const prioIds = new Set(prioridad.map((f) => f.id));
  const bySem = {};
  for (const f of cand) if (!f.prioridad) (bySem[f.s] = bySem[f.s] || []).push(f);
  const semKeys = Object.keys(bySem).sort((a, b) => a - b);

  const soluciones = [];
  const seen = new Set();
  for (let iter = 0; iter < 600; iter++) {
    // Primero las reprobadas a recursar; luego lo demás, del semestre más bajo al más alto.
    const orden = shuffle([...prioridad]);
    for (const s of semKeys) orden.push(...shuffle([...bySem[s]]));

    const elegidas = [];
    let uaAcum = 0;
    for (const f of orden) {
      if (elegidas.length >= addMax) break;
      if (uaAcum + f.ua > uaDisponibles) continue;
      const ops = shuffle(f.ofs).filter((of) => !elegidas.some((e) => sesionesChocan(e.sesiones, of.sesiones)));
      if (ops.length) {
        const of = ops[0];
        elegidas.push({
          sid: f.id, oferta: of.id, materia: f.name, matReal: of.materia, maestro: of.profesor, grupo: of.grupo,
          edificio: of.edificio, salon: of.salon, sesiones: of.sesiones,
          cred: f.cred, tipo: f.recurse ? "recurse" : "nueva", _auto: true,
        });
        uaAcum += f.ua;
      }
    }
    if (!elegidas.length) continue;
    const key = elegidas.map((e) => e.sid + ":" + e.grupo).sort().join("|");
    if (seen.has(key)) continue;
    seen.add(key);
    soluciones.push({ elegidas, placed: elegidas.length, prio: elegidas.filter((e) => prioIds.has(e.sid)).length,
                      huecos: contarHuecos(base.concat(elegidas)) });
  }

  if (!soluciones.length) {
    autoPool = []; if (otraBtn) otraBtn.hidden = true;
    resultEl.innerHTML = `<div class="auto-warn">⚠️ No se pudo cuadrar ninguna materia faltante en esa ventana. Amplía tu horario de entrada/salida o cambia de turno.</div>`;
    return;
  }

  // Gana la que mete más reprobadas a recursar; luego la que mete más materias; luego menos huecos.
  soluciones.sort((a, b) => b.prio - a.prio || b.placed - a.placed || a.huecos - b.huecos);
  const best = soluciones[0];
  autoPool = soluciones.filter((s) => s.prio === best.prio && s.placed === best.placed && s.huecos === best.huecos);
  autoLastKey = null;
  autoCtx = {
    totalFaltantes: faltantes.length,
    bloqueadasSer: bloqueadasSer.length,
    fueraVentana: fueraVentana.length,
    minSem, maxSem,
    prioridad: prioridad.map((f) => ({ id: f.id, name: f.name, sinGrupo: f.ofs.length === 0 })),
  };

  aplicarSolucionAuto();
}

// Aplica una solución del pool (aleatoria y distinta a la anterior) sobre la base manual
function aplicarSolucionAuto() {
  if (!autoPool.length || !autoCtx) return;
  const resultEl = document.getElementById("autoResult");
  const otraBtn = document.getElementById("autoOtraBtn");
  const base = state.horario.filter((h) => !h._auto);

  let pool = autoPool;
  if (autoPool.length > 1 && autoLastKey) {
    const filtered = autoPool.filter((s) => keyDeSol(s) !== autoLastKey);
    if (filtered.length) pool = filtered;
  }
  const sol = pool[Math.floor(Math.random() * pool.length)];
  autoLastKey = keyDeSol(sol);

  state.horario = base.concat(sol.elegidas);
  save();
  renderHorario();

  if (otraBtn) otraBtn.hidden = autoPool.length < 2;

  const totalCred = state.horario.reduce((a, e) => a + e.cred, 0);
  const colocadas = sol.elegidas.length;
  const sinFit = autoCtx.totalFaltantes - colocadas;
  const porSem = {};
  sol.elegidas.forEach((e) => {
    const m = e.sid.match(/^s(\d+)-/);
    const s = m ? parseInt(m[1]) : 0;
    (porSem[s] = porSem[s] || []).push(e);
  });
  const resumenSems = Object.keys(porSem).sort((a, b) => a - b)
    .map((s) => `${porSem[s].length} de ${PLAN[s].sem}`).join(", ");
  // Todo en una línea: lo agregado y, si hubo, lo que no cupo.
  resultEl.innerHTML = `<div class="auto-res${sinFit > 0 ? " con-aviso" : ""}">` +
    `<span>✅ <b>${colocadas}</b> agregada${colocadas === 1 ? "" : "s"} (${resumenSems})</span>` +
    `<span>${cargaActual().total} UA · ${fmt(totalCred)} cr · ${sol.huecos === 0 ? "sin horas muertas" : sol.huecos + " hueco" + (sol.huecos === 1 ? "" : "s")}</span>` +
    (sinFit > 0 ? `<span class="auto-res-warn" title="Amplía tu horario de entrada y salida, cambia de turno o agrégalas a mano">⚠️ ${sinFit} no ${sinFit === 1 ? "cupo" : "cupieron"} sin choques</span>` : "") +
    `</div>` + resumenRecursadas(sol);
}

// Qué reprobadas a recursar entraron primero y cuáles no, y por qué.
function resumenRecursadas(sol) {
  const prio = (autoCtx && autoCtx.prioridad) || [];
  if (!prio.length) return "";
  const dentro = new Set(sol.elegidas.map((e) => e.sid));
  const si = prio.filter((p) => dentro.has(p.id));
  const sinGrupo = prio.filter((p) => !dentro.has(p.id) && p.sinGrupo);
  const noCupo = prio.filter((p) => !dentro.has(p.id) && !p.sinGrupo);
  const lista = (xs) => xs.map((x) => esc(x.name)).join(", ");
  return `<div class="auto-recurse">🔁 <b>Recurse primero:</b> ` +
    (si.length ? `entró ${lista(si)}.` : "no entró ninguna.") +
    (sinGrupo.length ? ` Sin grupo de recurse en tu turno y horario: ${lista(sinGrupo)}.` : "") +
    (noCupo.length ? ` No cupo sin choques: ${lista(noCupo)}.` : "") +
    `</div>`;
}

document.getElementById("autoGenBtn").onclick = () => generarHorarioAuto();
document.getElementById("autoOtraBtn").onclick = () => {
  if (autoPool.length) aplicarSolucionAuto(); else generarHorarioAuto();
};

// P14: Borrar todo el horario
document.getElementById("clearHorarioBtn").onclick = () => {
  if (state.horario.length === 0) { alert("Tu horario ya está vacío."); return; }
  if (confirm(`¿Borrar las ${state.horario.length} materia(s) que tienes en el horario? Esta acción no se puede deshacer.`)) {
    state.horario = [];
    save();
    renderHorario();
    // refresca botones del plan
    planEl.querySelectorAll(".drop.open").forEach((d) => {
      const subj = d.closest(".subject");
      const m = subj.dataset.id.match(/^s(\d+)-(\d+)$/);
      if (m) renderDrop(d, parseInt(m[1]), parseInt(m[2]));
    });
  }
};

document.getElementById("backupBtn").onclick = () => {
  const blob = new Blob([JSON.stringify(state, null, 2)], { type: "application/json" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "avance_carrera.json";
  a.click();
  URL.revokeObjectURL(a.href);
};
document.getElementById("restoreBtn").onclick = () => document.getElementById("fileInput").click();
document.getElementById("fileInput").onchange = (e) => {
  const f = e.target.files[0];
  if (!f) return;
  const r = new FileReader();
  r.onload = async () => {
    let parsed;
    try {
      parsed = JSON.parse(r.result);
    } catch (err) {
      alert("Ese archivo no se pudo leer. Usa el respaldo .json que descargaste.");
      return;
    }
    state = {
      subjects: parsed.subjects || {},
      horario: parsed.horario || [],
      teacherMats: parsed.teacherMats || {},
      ingreso: parsed.ingreso || "",
    };
    save();
    if (await guardarAntesDeRecargar()) location.reload();
  };
  r.readAsText(f);
};
document.getElementById("resetBtn").onclick = async () => {
  const conCuenta = typeof USUARIO !== "undefined" && USUARIO;
  if (!confirm("¿Borrar todo tu avance, calificaciones, métricas y horario?" +
               (conCuenta ? " También se borra de tu cuenta." : ""))) return;
  state = blankState();
  save();
  if (await guardarAntesDeRecargar()) location.reload();
};

// Con sesión, primero se guarda en la cuenta y luego se recarga (cuenta.js).
async function guardarAntesDeRecargar() {
  if (typeof guardarEnCuentaYa !== "function") return true;
  try {
    await guardarEnCuentaYa();
    return true;
  } catch (e) {
    alert("No se pudo guardar en tu cuenta: " + e.message + ". Revisa tu conexión e intenta otra vez.");
    return false;
  }
}

