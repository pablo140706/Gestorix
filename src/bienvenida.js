// ============================================================
//  BIENVENIDA, MATERIAS REPROBADAS Y FECHAS (2026-11-21)
// ============================================================
// Pedido del usuario (CLAUDE.md §5):
//  · Al crear tu cuenta (o entrar a una cuenta todavía vacía) sale una
//    ventana. Sin cuenta NO sale: quien solo quiere ver, solo ve.
//      - nuevo ingreso → elige su grupo de 1.er semestre y se arma su horario;
//      - otro semestre → dice cuál va a cursar y lo anterior se marca como
//        "aprobada" sin calificación (las optativas las elige él).
//    En los dos casos pregunta el periodo de ingreso.
//  · Al marcar una materia como reprobada, una ventana pregunta si fue en
//    ordinario o en recurse y si presentó ETS, y explica qué sigue.
//  · En Mi avance: ingreso, egreso según el plan (8 semestres) y egreso a tu
//    ritmo (lo que te falta, a tu carga media por periodo).

// Lista de periodos para elegir el ingreso: del actual hacia atrás, 8 años.
function opcionesIngreso(elegido) {
  const hoy = perANum(periodoActual());
  let html = "";
  for (let n = hoy; n >= hoy - 16; n--) {
    const p = numAPer(n);
    html += `<option value="${p}"${p === elegido ? " selected" : ""}>${p} · ${perInicio(p)}</option>`;
  }
  return html;
}

// ---------- fechas en Mi avance ----------
function uaPendientes() {
  let ua = 0;
  PLAN.forEach((blk, s) => blk.materias.forEach(([name], i) => {
    const id = idOf(s, i);
    if (getSub(id, name).status !== "aprobada") ua += uaDe(id);
  }));
  return ua;
}

// Cuántos periodos te faltan a tu carga media, contando el que está en curso.
function egresoARitmo() {
  const ua = uaPendientes();
  if (ua === 0) return null;
  // A la carga media; si en tu horario llevas más (sin pasar tu máximo), a esa.
  const enHorario = typeof cargaActual === "function" ? cargaActual().total : 0;
  const ritmo = Math.min(cargaMaxPermitida(), Math.max(CARGA.media, enHorario));
  const n = Math.ceil(ua / ritmo);
  return { per: numAPer(perANum(periodoActual()) + n - 1), ua, n, ritmo };
}

function pintarFechas() {
  const el = document.getElementById("fechas");
  if (!el) return;
  const ing = perANum(state.ingreso) !== null ? state.ingreso : "";
  const r = egresoARitmo();
  const partes = [];
  if (ing) {
    const plan = numAPer(perANum(ing) + 7);   // 8 semestres: el de ingreso + 7
    partes.push(`<span class="fecha"><b>Ingreso</b> ${esc(ing)} <small>${perInicio(ing)}</small></span>`);
    partes.push(`<span class="fecha" title="8 semestres desde tu ingreso"><b>Egreso según el plan</b> ${plan} <small>${perFin(plan)}</small></span>`);
  } else {
    partes.push(`<span class="fecha">Pon tu <button class="linkbtn" type="button" data-bv="ingreso">periodo de ingreso</button> para ver tu egreso según el plan.</span>`);
  }
  partes.push(r
    ? `<span class="fecha" title="Te faltan ${r.ua} UA. A ${r.ritmo === CARGA.media ? "tu carga media" : "la carga de tu horario"} (${r.ritmo} UA por periodo) son ${r.n} periodo${r.n === 1 ? "" : "s"}, contando ${periodoActual()}."><b>Egreso a tu ritmo</b> ${r.per} <small>${perFin(r.per)}</small></span>`
    : `<span class="fecha"><b>¡Ya acreditaste todo el plan!</b></span>`);
  el.innerHTML = partes.join("") +
    `<span class="fechas-acc">${ing ? `<button class="linkbtn" type="button" data-bv="ingreso">Cambiar ingreso</button>` : ""}` +
    `<button class="linkbtn" type="button" data-bv="saes">Importar de SAES</button>` +
    `<button class="linkbtn" type="button" data-bv="guia">Guía de inicio</button></span>`;
  pintarAvisoEscolar();
}

// ---------- aviso de desfase y dictamen en Mi avance ----------
// docs/reglas-escolares.md. Lo pinta pintarFechas() en cada render().
function pintarAvisoEscolar() {
  const el = document.getElementById("avisoEscolar");
  if (!el) return;
  const dictamen = [], carta = [], ultimo = [], sinPer = [];
  PLAN.forEach((blk, s) => blk.materias.forEach(([name], i) => {
    const id = idOf(s, i);
    const rec = getSub(id, name);
    if (!rec.reproboCurso || rec.porEts) return;
    const liga = `<button class="linkbtn" type="button" data-sit-id="${id}">${esc(rec.name)}</button>`;
    if (rec.desfase === "dictamen") dictamen.push(liga);
    else if (rec.desfase === "carta24") carta.push(liga);
    else if (rec.desfase === "ultimo") ultimo.push({ liga, rec });
    else if (!rec.per_rep) sinPer.push(liga);
  }));
  const partes = [];
  if (dictamen.length) {
    partes.push(`<p data-nivel="grave">⛔ <b>Dictamen:</b> ${dictamen.join(", ")}. 4 semestres sin pasarla:
      solo tienes derecho a <b>ETS</b> y <b>no puedes inscribir nada</b> hasta pasarlo.</p>`);
  }
  if (carta.length) {
    partes.push(`<p data-nivel="grave">⚠️ <b>Desfasada${carta.length === 1 ? "" : "s"}:</b> ${carta.join(", ")}.
      No la${carta.length === 1 ? "" : "s"} pasaste en 3 semestres: te reinscribes con <b>carta de 24 créditos</b>
      (menos materias) y te comprometes a pasarla${carta.length === 1 ? "" : "s"} por ETS.</p>`);
  }
  if (ultimo.length) {
    partes.push(`<p data-nivel="aviso">⏳ <b>Tu 3.er semestre para pasarla</b> (${periodoActual()}): ` +
      ultimo.map(({ liga, rec }) => `${liga} (${rec.soloEts ? "pásala en ETS" : "recúrsala o pásala en ETS"})`).join(", ") +
      `. Si no, se desfasa y te inscribes con carta de 24 créditos.</p>`);
  }
  if (sinPer.length) {
    partes.push(`<p data-nivel="info">¿Cuándo reprobaste ${sinPer.join(", ")}? Dinos el periodo para avisarte antes de que se desfase.</p>`);
  }
  el.innerHTML = partes.join("");
  el.hidden = partes.length === 0;
}

document.getElementById("avisoEscolar")?.addEventListener("click", (e) => {
  const b = e.target.closest("[data-sit-id]");
  if (!b) return;
  const m = b.dataset.sitId.match(/^s(\d+)-(\d+)$/);
  abrirSituacion(b.dataset.sitId, getSub(b.dataset.sitId, PLAN[+m[1]].materias[+m[2]][0]).name);
});

document.getElementById("fechas")?.addEventListener("click", (e) => {
  const b = e.target.closest("[data-bv]");
  if (!b) return;
  abrirBienvenida(b.dataset.bv === "guia" ? "inicio" : b.dataset.bv);
});

// ---------- ventana de bienvenida ----------
const bvEl = document.getElementById("bienvenida");
const bvTit = document.getElementById("bienvenidaTit");
const bvBody = document.getElementById("bienvenidaBody");
// "1" = esa cuenta ya la vio (la usó o la cerró). Se guarda por cuenta, con
// una huella del correo (no el correo), para que otra cuenta nueva en el
// mismo navegador sí la vea.
function bvKey() {
  const c = (typeof USUARIO !== "undefined" && USUARIO && USUARIO.correo) || "";
  let h = 5381;
  for (let i = 0; i < c.length; i++) h = ((h * 33) ^ c.charCodeAt(i)) >>> 0;
  return "gestorix_bienvenida_" + h.toString(36);
}

function marcarBienvenidaVista() {
  try { localStorage.setItem(bvKey(), "1"); } catch (e) { /* modo privado */ }
}

function avanceVacio() {
  return !state.ingreso && state.horario.length === 0 &&
    Object.values(state.subjects).every((r) =>
      !r.calif && !r.res && !r.calif_ets && !r.res_ets && Number(r.veces || 1) === 1);
}

// La llama cuenta.js cuando ya hay sesión y bajó tus datos (al activar la
// cuenta, al entrar o al recargar) y portada.js al entrar a la app. Solo abre
// con sesión y si la cuenta de veras no tiene nada. Regresa si la abrió.
let bvMensaje = "";
function revisarBienvenida(mensaje) {
  if (window.__recargando) return false;
  if (typeof USUARIO === "undefined" || !USUARIO) return false;           // sin cuenta: solo ver
  let vista = false;
  try { vista = localStorage.getItem(bvKey()) === "1"; } catch (e) { /* modo privado */ }
  if (vista || !avanceVacio()) return false;
  if (document.getElementById("app")?.hidden) return false;                 // la portada sigue enfrente
  if (typeof hayHorarioEnURL === "function" && hayHorarioEnURL()) return false; // vino a ver un horario compartido
  if ([...document.querySelectorAll(".modal")].some((m) => !m.hidden)) return false;
  bvMensaje = mensaje || "";
  abrirBienvenida("inicio");
  return true;
}

const LETRA_DE_CARRERA = Object.fromEntries(Object.entries(LETRA_CARRERA).map(([l, c]) => [c, l]));

// Grupos de 1.er semestre de nuevo ingreso: los regulares, del 1 al 6 (del 7
// en adelante son de recurse; ver esGrupoRecurse en core.js).
function gruposDeNuevoIngreso() {
  const re = new RegExp("^1" + LETRA_DE_CARRERA[CARRERA] + "[MV]\\d+$");
  const cuenta = {};
  schedActual().forEach((e) => {
    if (re.test(e.grupo) && !esGrupoRecurse(e.grupo)) cuenta[e.grupo] = (cuenta[e.grupo] || 0) + 1;
  });
  return Object.keys(cuenta).sort().map((g) => ({ g, n: cuenta[g], turno: turnoDeGrupo(g) }));
}

function abrirBienvenida(paso) {
  if (paso === "saes") saesLeido = null;
  bvTit.textContent = paso === "ingreso" ? "Tu periodo de ingreso"
    : paso === "saes" ? "Importar de SAES"
    : (typeof USUARIO !== "undefined" && USUARIO) ? "Tu cuenta está lista" : "Guía de inicio";
  bvBody.innerHTML = PASOS_BV[paso]();
  bvBody.dataset.paso = paso;
  abrirModal(bvEl);
  if (paso === "otro") ajustarSemestreSugerido();
}

function cerrarBienvenida() {
  marcarBienvenidaVista();
  bvMensaje = "";
  cerrarModal(bvEl);
}

const campoIngreso = (elegido) => `
  <label class="campo">¿En qué periodo entraste a ${esc(CARRERA)}?
    <select id="bvIngreso">${opcionesIngreso(elegido)}</select></label>`;

const PASOS_BV = {
  inicio: () => `
    ${bvMensaje ? `<p class="bv-ok">${esc(bvMensaje)}</p>` : ""}
    <p class="bv-intro">${(typeof USUARIO !== "undefined" && USUARIO)
      ? "Para que tu avance quede guardado en tu cuenta, dinos en qué vas."
      : "Dinos en qué vas."} Todo se puede cambiar después en <b>Mi avance</b>.</p>
    <div class="bv-opciones">
      <button class="bv-op" type="button" data-ir="nuevo">
        <b>🎒 Soy de nuevo ingreso</b><span>Elige tu grupo y te armamos tu horario de 1.er semestre.</span></button>
      <button class="bv-op" type="button" data-ir="otro">
        <b>📚 Ya voy en otro semestre</b><span>Marca de una vez las materias que ya pasaste.</span></button>
      <button class="bv-op" type="button" data-ir="saes">
        <b>🏫 Importar de SAES</b><span>Pega tu "Estado General" y marcamos tus reprobadas, las que debes y las desfasadas.</span></button>
    </div>
    <p class="bv-nota">🔒 No tienes que dar tus calificaciones: en cada materia puedes poner solo
      <b>Aprobada</b> o <b>Reprobada</b>, sin número. Esas no entran a tu promedio.</p>
    <div class="bv-pie"><button class="linkbtn" type="button" data-bv-cerrar>Ahora no</button></div>`,

  nuevo: () => {
    const grupos = gruposDeNuevoIngreso();
    const boton = (x) => `<button class="bv-grupo" type="button" data-grupo="${esc(x.g)}">
        <b>${esc(x.g)}</b><span>${x.turno === "V" ? "🌙 Vespertino" : "☀️ Matutino"}</span></button>`;
    return `
      ${campoIngreso(periodoActual())}
      <p class="bv-pregunta">¿En qué grupo quedaste?</p>
      ${grupos.length
        ? `<div class="bv-grupos">${grupos.map(boton).join("")}</div>`
        : `<p class="drop-empty">No hay grupos de 1.er semestre cargados este periodo.</p>`}
      <p class="bv-nota">Metemos a tu horario todas las materias de ese grupo, con sus profes y salones.
        Luego puedes cambiar cualquiera en <b>Generar horario</b>.</p>
      <div class="bv-pie"><button class="linkbtn" type="button" data-ir="inicio">← Atrás</button>
        <button class="btn btn-primary" type="button" data-hacer="nuevo" disabled>Armar mi horario</button></div>`;
  },

  otro: () => `
    ${campoIngreso(numAPer(perANum(periodoActual()) - 2))}
    <label class="campo">¿Qué semestre vas a cursar ahora?
      <select id="bvSemestre">${PLAN.slice(1).map((_, k) =>
        `<option value="${k + 2}">${k + 2}.º semestre</option>`).join("")}</select></label>
    <div class="bv-nota" id="bvExplica"></div>
    <div class="bv-pie"><button class="linkbtn" type="button" data-ir="inicio">← Atrás</button>
      <button class="btn btn-primary" type="button" data-hacer="otro">Marcar mi avance</button></div>`,

  saes: () => `
    <p class="bv-intro">En SAES, en <b>Datos académicos</b>, abre una de estas páginas:</p>
    <ul class="saes-lista">
      <li><b>Kárdex</b>: tus calificaciones de lo que ya pasaste.</li>
      <li><b>Estado General</b>: tus reprobadas, las que debes y las desfasadas.</li>
    </ul>
    <p class="bv-nota">Guarda la página (<b>Ctrl + S</b>) y elígela aquí, o abre su código (<b>Ctrl + U</b>),
      cópialo todo y pégalo abajo. Puedes importar una y luego la otra.</p>
    <label class="campo">Archivo de la página
      <input type="file" id="bvSaesArchivo" accept=".html,.htm,.txt"></label>
    <label class="campo">…o pega el código aquí
      <textarea id="bvSaesTexto" rows="4" placeholder="&lt;html&gt;…"></textarea></label>
    <p class="bv-nota">🔒 Se lee en tu navegador: el archivo no se manda a ningún lado. Solo se guarda el
      avance que resulte.</p>
    <div id="bvSaesPrev"></div>
    <div class="bv-pie"><button class="linkbtn" type="button" data-ir="inicio">← Atrás</button>
      <button class="btn btn-primary" type="button" data-hacer="saes" disabled>Aplicar a mi avance</button></div>`,

  ingreso: () => `
    ${campoIngreso(state.ingreso || periodoActual())}
    <p class="bv-nota">Con esto calculamos tu egreso según el plan (8 semestres desde que entraste).</p>
    <div class="bv-pie"><button class="linkbtn" type="button" data-bv-cerrar>Cancelar</button>
      <button class="btn btn-primary" type="button" data-hacer="ingreso">Guardar</button></div>`,
};

// "Otro semestre": el semestre sugerido sale del ingreso (entraste en 25/1 y
// estamos en 27/1 → vas a 5.º), mientras no lo cambies tú.
let semestreTocado = false;
function ajustarSemestreSugerido() {
  semestreTocado = false;
  sugerirSemestre();
}
function sugerirSemestre() {
  const sel = document.getElementById("bvSemestre");
  const ing = document.getElementById("bvIngreso");
  if (!sel || !ing) return;
  if (!semestreTocado) {
    const sug = perANum(periodoActual()) - perANum(ing.value) + 1;
    sel.value = String(Math.min(PLAN.length, Math.max(2, sug)));
  }
  explicarOtro();
}
function explicarOtro() {
  const n = Number(document.getElementById("bvSemestre").value);
  const ultimo = n - 1;
  const conOptativas = PLAN.slice(0, ultimo).some((blk, s) => blk.materias.some((_, i) => OPT_SLOTS[idOf(s, i)]));
  document.getElementById("bvExplica").innerHTML =
    `Se marcan como <b>aprobadas sin calificación</b> las materias de 1.º a ${ultimo}.º semestre` +
    ` (las que ya tengas capturadas no se tocan). Después, en <b>Mi avance</b>, cambia a
     <b>Reprobada</b> las que reprobaste o ponles número si quieres.` +
    (conOptativas ? `<br><br>Las <b>optativas</b> no se marcan: elige tú cuáles cursaste.` : "");
}

bvBody.addEventListener("change", (e) => {
  if (e.target.id === "bvSemestre") { semestreTocado = true; explicarOtro(); }
  if (e.target.id === "bvIngreso" && bvBody.dataset.paso === "otro") sugerirSemestre();
});

bvBody.addEventListener("click", (e) => {
  const t = e.target.closest("button");
  if (!t) return;
  if (t.matches("[data-bv-cerrar]")) { cerrarBienvenida(); return; }
  if (t.dataset.ir) { abrirBienvenida(t.dataset.ir); return; }
  if (t.dataset.grupo) {
    bvBody.querySelectorAll(".bv-grupo").forEach((b) => b.classList.toggle("elegido", b === t));
    bvBody.querySelector("[data-hacer='nuevo']").disabled = false;
    bvBody.dataset.grupo = t.dataset.grupo;
    return;
  }
  if (t.dataset.hacer) hacerBienvenida(t.dataset.hacer);
  if (t.dataset.fin) {
    cerrarBienvenida();
    irAPestana(t.dataset.fin);
    window.scrollTo(0, 0);
  }
});

// ---------- importar el "Estado General" de SAES ----------
// La página trae tres tablas: reprobadas (semestre, clave, nombre, periodo
// "20261", veces cursada), no cursadas y desfasadas. Se leen con DOMParser,
// que NO ejecuta los scripts de la página, y nada sale del navegador.
let saesLeido = null;

function periodoDeSaes(c) {           // "20261", "2026/1" o "26/1" → "26/1"
  const m = /^(?:20)?(\d{2})\s*[\/-]?\s*([12])$/.exec(String(c || "").trim());
  return m ? m[1] + "/" + m[2] : "";
}

// Kárdex (Datos académicos → Kárdex): tablas con clave, materia, periodo,
// forma de evaluación y calificación. Las columnas se ubican por su título
// ("Clave", "Calificación"…); si no hay títulos, por la forma del dato.
function leerKardex(html) {
  const doc = new DOMParser().parseFromString(html, "text/html");
  const porClave = new Map();
  const esNum = (x) => /^\d{1,2}(\.\d+)?$/.test(x || "");
  doc.querySelectorAll("table").forEach((tabla) => {
    let idx = null;
    [...tabla.rows].forEach((tr) => {
      if (tr.querySelector("table")) return;                 // fila que solo envuelve otra tabla
      const c = [...tr.cells].map((td) => td.textContent.replace(/ /g, " ").replace(/\s+/g, " ").trim());
      if (c.some((x) => /^calif/i.test(x))) {               // fila de títulos
        const busca = (re) => c.findIndex((x) => re.test(x));
        idx = { clave: busca(/^clave/i), nombre: busca(/materia|unidad|asignatura|descrip/i),
                periodo: busca(/periodo/i), forma: busca(/forma|eval|tipo/i), calif: busca(/^calif/i),
                fecha: busca(/fecha/i) };
        return;
      }
      const col = (k) => (idx && idx[k] >= 0 ? c[idx[k]] : undefined);
      const clave = /^[A-Z]\d{3}$/.test(col("clave") || "") ? col("clave") : c.find((x) => /^[A-Z]\d{3}$/.test(x));
      if (!clave) return;
      const califTxt = esNum(col("calif")) ? col("calif") : [...c].reverse().find(esNum);
      const n = Number(califTxt);
      if (!esNum(califTxt) || n > 10) return;
      const f = {
        clave,
        nombre: col("nombre") || "",
        calif: Math.round(n),
        forma: col("forma") || c.find((x) => /^(ORD|EXT|ETS|REC|T[IÍ]TULO)/i.test(x)) || "",
        periodo: periodoDeSaes(col("periodo") || c.find((x) => periodoDeSaes(x))),
        // La fecha del acta sirve para el periodo cuando no viene la columna, y
        // la más antigua de todas es tu ingreso (usuario, 2026-11-25).
        fecha: col("fecha") || c.find((x) => fechaDeSaes(x)) || "",
      };
      // El curso y el ETS son renglones distintos y se guardan por separado: un
      // ETS reprobado ya no borra la del ordinario (usuario, 2026-11-25).
      // Dentro de cada uno, si sale repetido se queda la calificación más alta.
      const k = clave + (/ETS|T[IÍ]TULO/i.test(f.forma) ? "|ETS" : "");
      const ya = porClave.get(k);
      if (!ya || f.calif > ya.calif) porClave.set(k, f);
    });
  });
  return porClave.size ? { tipo: "kardex", filas: [...porClave.values()] } : null;
}

// Lugar de optativa para una clave del Kárdex: el que ya la tenga o el primero
// libre de su semestre. Con `asignar`, lo deja apartado en `state`.
function slotDeOptativa(clave, asignar) {
  const opt = PLAN_ACTIVO.optativas.find((o) => o.clave === clave);
  if (!opt) return null;
  const ya = Object.keys(OPT_SLOTS).find((k) => (state.subjects[k] || {}).clave === clave);
  if (ya) return ya;
  const libre = Object.keys(OPT_SLOTS).find((k) => OPT_SLOTS[k].sem === opt.sem && !(state.subjects[k] || {}).clave);
  if (libre && asignar) {
    state.subjects[libre] = Object.assign({}, state.subjects[libre] || {}, { clave, name: nombreDeSlot(libre, opt.saes) });
  }
  return libre || null;
}

function leerEstadoGeneral(html) {
  const doc = new DOMParser().parseFromString(html, "text/html");
  const tablas = ["mainCopy_GV_Reprobadas", "mainCopy_GV_Adeudadas", "mainCopy_GV_Desfasadas"];
  // Solo por sus tablas: el menú de SAES (también en el Kárdex) dice "materias reprobadas".
  if (!tablas.some((t) => doc.getElementById(t))) return null;
  const filas = (t) => [...doc.querySelectorAll(`#${t} tr`)].map((tr) => {
    const c = [...tr.cells].map((td) => td.textContent.replace(/ /g, " ").trim());
    const clave = c.find((x) => /^[A-Z]\d{3}$/.test(x));
    if (!clave) return null;                       // encabezado
    return { sem: Number(c[0]) || 0, clave, nombre: c[2] || clave,
             periodo: periodoDeSaes(c.find((x) => /^20\d{2}[12]$/.test(x))),
             veces: Math.min(2, Math.max(1, Number(c[c.length - 1]) || 1)) };
  }).filter(Boolean);
  const r = { rep: filas(tablas[0]), noc: filas(tablas[1]), des: filas(tablas[2]) };
  // Semestres que cubre el Estado General: lo que no aparece de ahí para atrás
  // se propone como aprobado (sin número).
  const hasta = Math.max(0, ...[...r.rep, ...r.noc, ...r.des].map((f) => f.sem));
  const listadas = new Set([...r.rep, ...r.noc, ...r.des].map((f) => f.clave));
  r.aprob = [];
  for (let s = 0; s < Math.min(hasta, PLAN.length); s++) {
    PLAN[s].materias.forEach(([name], i) => {
      const id = idOf(s, i);
      const clave = CLAVE_DE_ID[id];
      if (!clave || OPT_SLOTS[id] || listadas.has(clave)) return;
      r.aprob.push({ id, clave, nombre: getSub(id, name).name, inscrita: estaInscrita(id) });
    });
  }
  r.hasta = hasta;
  r.tipo = "estado";
  return r;
}

function pintarVistaSaes() {
  const prev = document.getElementById("bvSaesPrev");
  const boton = bvBody.querySelector("[data-hacer='saes']");
  if (!saesLeido) {
    prev.innerHTML = `<p class="sit-aviso" data-nivel="aviso">No encontré ni el Kárdex ni el Estado General. Revisa que sea una de esas páginas de SAES.</p>`;
    boton.disabled = true;
    return;
  }
  if (saesLeido.tipo === "kardex") { pintarVistaKardex(prev); boton.disabled = false; return; }
  const r = saesLeido;
  const sinPlan = [...r.rep, ...r.noc, ...r.des].filter((f) => !ID_DE_CLAVE[f.clave]);
  // El nombre del plan trae acentos; el de SAES no.
  const nombre = (f) => {
    const m = /^s(\d+)-(\d+)$/.exec(ID_DE_CLAVE[f.clave] || "");
    return m ? PLAN[+m[1]].materias[+m[2]][0] : titleCase(f.nombre);
  };
  const linea = (f, extra) => `<li><b>${esc(f.clave)}</b> ${esc(nombre(f))}${extra ? ` <small>${extra}</small>` : ""}</li>`;
  const repTxt = (f) => `${f.veces === 2 ? "recurse · solo ETS" : "1.ª vez"}${f.periodo ? " · " + f.periodo : ""}` +
    ({ dictamen: " · ⛔ dictamen", carta24: " · ⚠️ desfasada (carta 24 cr)", ultimo: " · ⏳ 3.er semestre" }[desfaseDe(f.periodo)] || "");
  prev.innerHTML = `
    ${r.rep.length ? `<p class="bv-pregunta">Reprobadas (${r.rep.length})</p><ul class="saes-lista">${r.rep.map((f) => linea(f, repTxt(f))).join("")}</ul>` : ""}
    ${r.des.length ? `<p class="bv-pregunta">Desfasadas (${r.des.length})</p><ul class="saes-lista">${r.des.map((f) => linea(f, "⚠️ necesitas dictamen")).join("")}</ul>` : ""}
    ${r.noc.length ? `<p class="bv-pregunta">No cursadas (${r.noc.length}) <small>· se quedan pendientes</small></p><ul class="saes-lista">${r.noc.map((f) => linea(f)).join("")}</ul>` : ""}
    ${r.aprob.length ? `<p class="bv-pregunta">Aprobadas sin número (${r.aprob.length}) <small>· las demás de 1.º a ${r.hasta}.º; quita la palomita a la que estés cursando</small></p>
      <div class="saes-aprob">${r.aprob.map((a) => `<label><input type="checkbox" data-aprob="${a.id}"${a.inscrita ? "" : " checked"}> ${esc(a.nombre)}</label>`).join("")}</div>` : ""}
    ${sinPlan.length ? `<p class="bv-nota">No están en tu plan y no se tocan: ${sinPlan.map((f) => esc(f.clave)).join(", ")}.</p>` : ""}`;
  boton.disabled = false;
}

// Nombre con acentos: el del plan (o el del lugar de optativa), si no el de SAES.
function nombreParaVista(clave, nombreSaes) {
  const m = /^s(\d+)-(\d+)$/.exec(ID_DE_CLAVE[clave] || "");
  if (m) return PLAN[+m[1]].materias[+m[2]][0];
  const opt = PLAN_ACTIVO.optativas.find((o) => o.clave === clave);
  return titleCase(opt ? opt.saes.split("|")[0] : nombreSaes || clave);
}

function pintarVistaKardex(prev) {
  const filas = saesLeido.filas;
  const enPlan = filas.filter((f) => ID_DE_CLAVE[f.clave] || slotDeOptativa(f.clave, false));
  const fuera = filas.filter((f) => !enPlan.includes(f));
  const aprob = enPlan.filter((f) => f.calif >= 6);
  const prom = aprob.length ? (aprob.reduce((a, f) => a + f.calif, 0) / aprob.length).toFixed(2) : "—";
  const detalle = (f) => {
    const partes = [];
    if (/ETS|T[IÍ]TULO/i.test(f.forma)) partes.push(f.calif >= 6 ? "aprobada por ETS" : "ETS reprobado");
    else if (f.forma) partes.push(f.forma);
    if (f.periodo) partes.push(f.periodo);
    if (!ID_DE_CLAVE[f.clave]) partes.push("lugar de optativa");
    return partes.join(" · ");
  };
  prev.innerHTML = `
    <p class="bv-pregunta">Calificaciones del Kárdex (${enPlan.length}) <small>· promedio de las aprobadas: ${prom}</small></p>
    <ul class="saes-lista">${enPlan.map((f) => `<li><b>${f.calif}</b> ${esc(nombreParaVista(f.clave, f.nombre))}
      <small>${esc(f.clave)}${detalle(f) ? " · " + esc(detalle(f)) : ""}</small></li>`).join("")}</ul>
    ${fuera.length ? `<p class="bv-nota">No están en tu plan y no se tocan: ${fuera.map((f) => esc(f.clave)).join(", ")}.</p>` : ""}
    <p class="bv-nota">Estas calificaciones reemplazan lo que tengas capturado en esas materias.</p>`;
}

function leerSaes(texto) {
  saesLeido = texto.trim() ? (leerEstadoGeneral(texto) || leerKardex(texto)) : null;
  if (texto.trim()) pintarVistaSaes();
  else { document.getElementById("bvSaesPrev").innerHTML = ""; bvBody.querySelector("[data-hacer='saes']").disabled = true; }
}

bvBody.addEventListener("input", (e) => {
  if (e.target.id === "bvSaesTexto") leerSaes(e.target.value);
});
bvBody.addEventListener("change", (e) => {
  if (e.target.id !== "bvSaesArchivo" || !e.target.files[0]) return;
  const lector = new FileReader();
  lector.onload = () => leerSaes(String(lector.result));
  lector.readAsText(e.target.files[0]);
});

// Kárdex: cada calificación queda con su número (al promedio entra la más
// alta). El curso (ordinario o recurse) y el ETS van en campos distintos, así
// que un ETS reprobado no borra la del ordinario. Si dice recurse, 2.ª vez.
function aplicarKardex() {
  // Tu ingreso es el periodo más antiguo del Kárdex: ahí empezaste a cursar
  // (usuario, 2026-11-25; un acta del 19 de enero de 2026 cae en 26/1). Solo
  // se mueve hacia atrás: el Kárdex manda sobre el ingreso que hayas dicho.
  const perDe = (f) => f.periodo || periodoDeFecha(fechaDeSaes(f.fecha));
  const masAntiguo = saesLeido.filas.reduce((a, f) => perMasAntiguo(a, perDe(f)), "");
  if (masAntiguo && perMasAntiguo(masAntiguo, state.ingreso) === masAntiguo) state.ingreso = masAntiguo;

  // Una misma materia puede traer dos renglones: el del curso y el del ETS.
  const porId = new Map();
  saesLeido.filas.forEach((f) => {
    const id = ID_DE_CLAVE[f.clave] || slotDeOptativa(f.clave, true);
    if (!id) return;
    const g = porId.get(id) || { curso: null, ets: null, rec: false, perOrd: "" };
    if (/ETS|T[IÍ]TULO/i.test(f.forma)) {
      if (!g.ets || f.calif > g.ets.calif) g.ets = f;
    } else {
      if (!g.curso || f.calif > g.curso.calif) g.curso = f;
      // El desfase se cuenta desde el ORDINARIO. Si el renglón es del recurse,
      // el ordinario fue a más tardar el periodo anterior.
      const per = perDe(f);
      if (per) g.perOrd = perMasAntiguo(g.perOrd, /REC/i.test(f.forma) ? numAPer(perANum(per) - 1) : per);
      if (/REC/i.test(f.forma)) g.rec = true;
    }
    porId.set(id, g);
  });

  let n = 0;
  porId.forEach((g, id) => {
    const cur = state.subjects[id] || {};
    const calif = g.curso ? String(g.curso.calif) : "";
    // Si solo aparece el ETS, el curso se reprobó aunque el Kárdex no diga con cuánto.
    const res = calif === "" && g.ets ? "reprobada" : "";
    const reproboCurso = calif !== "" ? Number(calif) < 6 : res === "reprobada";
    state.subjects[id] = Object.assign({}, cur, {
      calif,
      res,
      // El ETS solo existe si reprobaste el curso (lo exige la base).
      calif_ets: g.ets && reproboCurso ? String(g.ets.calif) : "",
      res_ets: "",
      veces: g.rec ? 2 : Number(cur.veces || 1),
      per_rep: reproboCurso ? perDesdeIngreso(perMasAntiguo(g.perOrd, cur.per_rep), state.ingreso) : "",
    });
    if (!canInscribir(getSub(id, ""))) state.horario = state.horario.filter((h) => h.sid !== id);
    n++;
  });
  return n;
}

// Lo que dice SAES manda sobre lo capturado en esas materias.
function aplicarSaes() {
  const r = saesLeido;
  if (r.tipo === "kardex") return aplicarKardex();
  let n = 0;
  const poner = (clave, datos) => {
    const id = ID_DE_CLAVE[clave];
    if (!id) return;
    state.subjects[id] = Object.assign({}, state.subjects[id] || {}, datos);
    n++;
  };
  // Si ya trae número (p. ej. del Kárdex) no se pisa, y se queda el periodo más
  // periodo MÁS ANTIGUO: el desfase se cuenta desde el ordinario (el Estado General lo da; el Kárdex, el recurse).
  r.rep.forEach((f) => {
    const cur = state.subjects[ID_DE_CLAVE[f.clave]] || {};
    const conNumero = cur.calif !== undefined && cur.calif !== "" && Number(cur.calif) < 6;
    const per = perDesdeIngreso(perMasAntiguo(cur.per_rep, f.periodo), state.ingreso);
    poner(f.clave, conNumero
      ? { veces: Math.max(f.veces, Number(cur.veces || 1)), per_rep: per }
      : { calif: "", res: "reprobada", veces: f.veces, calif_ets: "", res_ets: "", per_rep: per });
  });
  // Desfasada sin periodo: se pone uno de hace 3 periodos para que salga como
  // tal, pero nunca antes de tu ingreso.
  r.des.forEach((f) => poner(f.clave, { calif: "", res: "reprobada", veces: f.veces, calif_ets: "", res_ets: "",
    per_rep: perDesdeIngreso(esDesfasada(desfaseDe(f.periodo)) ? f.periodo : numAPer(perANum(periodoActual()) - 3), state.ingreso) }));
  r.noc.forEach((f) => poner(f.clave, { calif: "", res: "", veces: 1, calif_ets: "", res_ets: "", per_rep: "" }));
  bvBody.querySelectorAll("[data-aprob]:checked").forEach((c) => {
    const id = c.dataset.aprob;
    const rec = getSub(id, "");
    if (rec.status === "aprobada") return;                 // ya estaba aprobada (con o sin número)
    state.subjects[id] = Object.assign({}, state.subjects[id] || {}, { res: "aprobada", calif: "", veces: 1, calif_ets: "", res_ets: "", per_rep: "" });
    state.horario = state.horario.filter((h) => h.sid !== id);
    n++;
  });
  // Lo que ya no se puede inscribir (solo por ETS) sale del horario.
  state.horario = state.horario.filter((h) => canInscribir(getSub(h.sid, "")));
  return n;
}

function hacerBienvenida(que) {
  const ingreso = document.getElementById("bvIngreso")?.value || "";
  if (perANum(ingreso) !== null) state.ingreso = ingreso;

  if (que === "ingreso") {
    save();
    render();
    cerrarBienvenida();
    return;
  }

  if (que === "nuevo") {
    const g = bvBody.dataset.grupo;
    const ya = state.horario.length;
    if (ya && !confirm(`Ya tienes ${ya} materia${ya === 1 ? "" : "s"} en tu horario. ¿Reemplazar las de 1.er semestre por las de ${g}?`)) return;
    const n = armarHorarioDeGrupo(g);
    save();
    sincronizarFilas();
    mostrarListo(`Listo: metimos <b>${n} materia${n === 1 ? "" : "s"}</b> de <b>${esc(g)}</b> a tu horario.`, "horario", "Ver mi horario");
    return;
  }

  if (que === "saes") {
    if (!saesLeido) return;
    const n = aplicarSaes();
    const r = saesLeido;
    saesLeido = null;
    save();
    sincronizarFilas();
    const otra = r.tipo === "kardex" ? "tu Estado General" : "tu Kárdex";
    mostrarListo(
      (r.tipo === "kardex"
        ? `Listo: pusimos <b>${n} calificaci${n === 1 ? "ón" : "ones"}</b> de tu Kárdex. Ya entran a tu promedio.`
        : `Listo: actualizamos <b>${n} materia${n === 1 ? "" : "s"}</b> con tu Estado General de SAES` +
          ` (${r.rep.length} reprobada${r.rep.length === 1 ? "" : "s"}, ${r.noc.length} sin cursar` +
          `${r.des.length ? `, ${r.des.length} desfasada${r.des.length === 1 ? "" : "s"}` : ""}).` +
          `<br><br>Revisa los avisos de <b>Mi avance</b>: ahí te decimos si alguna está por desfasarse.`) +
      `<br><br><button class="linkbtn" type="button" data-ir="saes">Importar también ${otra}</button>`,
      "plan", "Ir a Mi avance");
    return;
  }

  if (que === "otro") {
    const sem = Number(document.getElementById("bvSemestre").value);
    const r = marcarAnteriores(sem);
    save();
    sincronizarFilas();
    mostrarListo(
      `Marcamos <b>${r.n} materia${r.n === 1 ? "" : "s"}</b> de 1.º a ${sem - 1}.º como aprobadas sin calificación.` +
      (r.opt ? `<br><br>Te falta${r.opt === 1 ? "" : "n"} <b>${r.opt} optativa${r.opt === 1 ? "" : "s"}</b>: elige cuáles cursaste en <b>Optativas</b> y márcalas en Mi avance.` : "") +
      `<br><br>Si reprobaste alguna, búscala en <b>Mi avance</b> y cámbiala a <b>Reprobada</b>: te preguntaremos en qué situación quedó.`,
      "plan", "Ir a Mi avance");
  }
}

function mostrarListo(html, pestana, boton) {
  bvTit.textContent = "¡Listo!";
  bvBody.dataset.paso = "listo";
  bvBody.innerHTML = `<p class="bv-intro">${html}</p>
    <p class="bv-nota">Puedes volver a abrir esta guía desde <b>Guía de inicio</b>, abajo de tu avance.</p>
    <div class="bv-pie"><button class="btn btn-primary" type="button" data-fin="${pestana}">${boton}</button></div>`;
}

// Mete al horario las materias de 1.er semestre del grupo, en lugar de las
// que hubiera de ese semestre.
function armarHorarioDeGrupo(g) {
  const items = [];
  PLAN[0].materias.forEach((_, i) => {
    if (OPT_SLOTS[idOf(0, i)]) return;
    const e = scheduleFor(0, i).find((x) => x.grupo === g);
    if (e) items.push(armarItemHorario(e, 0, i));
  });
  const sids = new Set(items.map((x) => x.sid));
  state.horario = state.horario.filter((h) => !sids.has(h.sid)).concat(items);
  return items.length;
}

// Marca como aprobadas sin número las obligatorias de los semestres antes de
// `sem`, sin pisar lo ya capturado. Las optativas se cuentan, no se marcan.
function marcarAnteriores(sem) {
  let n = 0, opt = 0;
  for (let s = 0; s < sem - 1; s++) {
    PLAN[s].materias.forEach(([name], i) => {
      const id = idOf(s, i);
      if (OPT_SLOTS[id]) { if (getSub(id, name).status === "pendiente") opt++; return; }
      const r = state.subjects[id] || {};
      if (r.calif || r.res || r.calif_ets || r.res_ets || Number(r.veces || 1) !== 1) return;
      state.subjects[id] = Object.assign({}, r, { res: "aprobada" });
      // Si estaba en el horario, ya no va: está aprobada.
      state.horario = state.horario.filter((h) => h.sid !== id);
      n++;
    });
  }
  return { n, opt };
}

document.getElementById("bienvenidaCerrar").addEventListener("click", cerrarBienvenida);
bvEl.addEventListener("click", (e) => { if (e.target === bvEl) cerrarBienvenida(); });
document.addEventListener("keydown", (e) => { if (e.key === "Escape" && !bvEl.hidden) cerrarBienvenida(); });

// ---------- ventana de una materia reprobada ----------
const sitEl = document.getElementById("situacion");
const sitBody = document.getElementById("situacionBody");
let sitId = null;

function abrirSituacion(id, nombre) {
  sitId = id;
  const rec = getSub(id, nombre);
  const etsVal = rec.calif_ets !== "" ? (Number(rec.calif_ets) >= 6 ? "A" : "R") : rec.res_ets ? rec.res_ets[0].toUpperCase() : "";
  document.getElementById("situacionTit").textContent = "Reprobaste " + nombre;
  sitBody.innerHTML = `
    <p class="bv-intro">Cuéntanos cómo quedó para decirte qué sigue.</p>
    <fieldset class="sit-grupo"><legend>¿En qué curso la reprobaste?</legend>
      <label><input type="radio" name="sitVeces" value="1"${rec.veces === 1 ? " checked" : ""}> En ordinario (1.ª vez)</label>
      <label><input type="radio" name="sitVeces" value="2"${rec.veces === 2 ? " checked" : ""}> En recurse (2.ª vez)</label>
      <small class="sit-nota">Si la diste de baja, no cuenta como curso: vuelve a ser 1.ª vez.</small>
    </fieldset>
    <label class="campo sit-periodo">¿En qué periodo reprobaste el ordinario (la 1.ª vez)?
      <select id="sitPeriodo">${opcionesPeriodoReprobada(rec.per_rep)}</select></label>
    <fieldset class="sit-grupo"><legend>¿Ya presentaste el ETS?</legend>
      <label><input type="radio" name="sitEts" value=""${etsVal === "" ? " checked" : ""}> Todavía no</label>
      <label><input type="radio" name="sitEts" value="A"${etsVal === "A" ? " checked" : ""}> Sí, lo aprobé</label>
      <label><input type="radio" name="sitEts" value="R"${etsVal === "R" ? " checked" : ""}> Sí, lo reprobé</label>
      <label class="sit-num" hidden>Calificación del ETS (opcional)
        <select id="sitEtsNum"></select></label>
    </fieldset>
    <div class="sit-aviso" id="sitAviso" role="status"></div>
    <div class="bv-pie"><button class="linkbtn" type="button" data-sit="cerrar">Ahora no</button>
      <button class="btn btn-primary" type="button" data-sit="guardar">Guardar</button></div>`;
  actualizarSituacion(rec.calif_ets);
  abrirModal(sitEl);
}

// Periodos para "¿cuándo la reprobaste?": del actual hacia atrás, 4 años, pero
// nunca antes de tu ingreso: si entraste en 26/2 no pudiste reprobar en 26/1,
// porque no estabas inscrito (usuario, 2026-11-25). Si no lo ha dicho, se
// propone el anterior al actual.
function opcionesPeriodoReprobada(elegido) {
  const hoy = perANum(periodoActual());
  const ing = perANum(state.ingreso);
  const desde = Math.min(hoy, ing === null ? hoy - 8 : Math.max(hoy - 8, ing));
  const sel = perDesdeIngreso(elegido || numAPer(Math.max(desde, hoy - 1)), numAPer(desde));
  let html = "";
  for (let n = hoy; n >= desde; n--) {
    const p = numAPer(n);
    html += `<option value="${p}"${p === sel ? " selected" : ""}>${p} · ${perInicio(p)}–${perFin(p)}</option>`;
  }
  return html;
}

// Las opciones de número dependen de si lo aprobó (6–10) o lo reprobó (0–5).
function actualizarSituacion(numActual) {
  const ets = sitBody.querySelector("[name=sitEts]:checked").value;
  const veces = Number(sitBody.querySelector("[name=sitVeces]:checked").value);
  const numLbl = sitBody.querySelector(".sit-num");
  const numSel = document.getElementById("sitEtsNum");
  numLbl.hidden = ets === "";
  if (ets && numActual !== undefined) {
    const rango = ets === "A" ? [10, 9, 8, 7, 6] : [5, 4, 3, 2, 1, 0];
    numSel.innerHTML = `<option value="">Sin número</option>` +
      rango.map((n) => `<option value="${n}"${String(n) === String(numActual) ? " selected" : ""}>${n}</option>`).join("");
  }
  const conNum = numSel.value !== "";
  const ua = uaDe(sitId);
  let aviso;
  if (ets === "A") {
    aviso = `✅ Queda <b>aprobada por ETS</b>. ` +
      (conNum ? "Su calificación entra a tu promedio." : "Sin número no entra a tu promedio.");
  } else if (veces === 1) {
    aviso = `⚠️ Reprobaste en ordinario${ets === "R" ? " y también el ETS" : ""}. Tienes dos caminos:
      <b>recursarla</b> (inscribirla otra vez como 2.ª vez) o <b>${ets === "R" ? "volver a presentar" : "presentar"} ETS</b>.
      Si la recursas y la vuelves a reprobar, ya solo podrás acreditarla por ETS.`;
  } else {
    aviso = `⛔ Reprobaste el recurse: <b>ya no puedes volver a cursarla</b>, solo acreditarla por
      <b>ETS</b>${ets === "R" ? " (puedes volver a presentarlo)" : ""}. Mientras la debas, ocupa
      <b>${ua} UA</b> de tu carga aunque no esté en tu horario.`;
  }
  // Desfase según el periodo en que la reprobaste (docs/reglas-escolares.md).
  const desf = ets === "A" ? "" : desfaseDe(document.getElementById("sitPeriodo").value);
  if (desf) aviso += `<br><br>${desf === "ultimo" ? "⏳" : desf === "dictamen" ? "⛔" : "⚠️"} ${TEXTO_DESFASE[desf]}`;
  const aviEl = document.getElementById("sitAviso");
  aviEl.innerHTML = aviso;
  aviEl.dataset.nivel = ets === "A" ? "ok" : (veces === 1 && !esDesfasada(desf)) ? "aviso" : "grave";
}

sitBody.addEventListener("change", (e) => {
  if (e.target.name === "sitEts") actualizarSituacion("");
  else actualizarSituacion();
});

sitBody.addEventListener("click", (e) => {
  const b = e.target.closest("[data-sit]");
  if (!b) return;
  if (b.dataset.sit === "guardar") {
    const veces = Number(sitBody.querySelector("[name=sitVeces]:checked").value);
    const ets = sitBody.querySelector("[name=sitEts]:checked").value;
    const num = document.getElementById("sitEtsNum").value;
    setSub(sitId, {
      veces,
      calif_ets: ets ? num : "",
      res_ets: ets && num === "" ? (ets === "A" ? "aprobado" : "reprobado") : "",
      per_rep: document.getElementById("sitPeriodo").value,
    });
    planEl.querySelector(`.subject[data-id="${sitId}"]`)?._tras?.();
  }
  cerrarModal(sitEl);
});

document.getElementById("situacionCerrar").addEventListener("click", () => cerrarModal(sitEl));
sitEl.addEventListener("click", (e) => { if (e.target === sitEl) cerrarModal(sitEl); });
document.addEventListener("keydown", (e) => { if (e.key === "Escape") cerrarModal(sitEl); });

// Primer pintado de las fechas (render() ya corrió antes de que cargara este archivo).
pintarFechas();
