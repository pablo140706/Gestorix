// ============================================================
//  PESTAÑA 2 · MAESTROS
// ============================================================
let profSort = { key: "name", dir: "asc" };
let profTurno = "ambos";   // P16: ambos | M | V
let profMats = "todas";    // qué materias enseñar: todas | imparte | yano

// Las materias de un maestro se marcan verde o roja, y se puede filtrar y
// ordenar por eso. Sale de la base (MATS_DE_PROF en core.js), no se edita:
// verde = la da este periodo; rojo = la dio antes y este periodo ya no.
function matTitulo(x) {
  return x.active
    ? "La imparte este periodo"
    : `Ya no la imparte: la dio por última vez en ${x.periodo || "un periodo pasado"}`;
}

// Materias de un maestro visibles con el filtro actual
function matsVisibles(name) {
  const mats = teacherMaterias(name);
  if (profMats === "imparte") return mats.filter((x) => x.active);
  if (profMats === "yano") return mats.filter((x) => !x.active);
  return mats;
}
const profsHead = document.getElementById("profsHead");
const profsBody = document.getElementById("profsBody");
const searchProf = document.getElementById("searchProf");

// La lista de maestros NO se separa por carrera: las métricas son globales y un
// profe da clase donde da. El selector de carrera manda sobre el plan y las
// ofertas del horario, pero aquí se ven todos, con badge de en qué carrera dan.
function teachersActuales() {
  return TEACHERS;
}

const PROF_COLS = [
  { key: "name", label: "Maestro", type: "text" },
  { key: "calidad", label: "Calidad general", type: "num" },
  { key: "recomiendan", label: "Lo recomiendan", type: "num" },
  { key: "dificultad", label: "Nivel de dificultad", type: "num" },
];

function renderProfsHead() {
  profsHead.innerHTML = `<tr>${PROF_COLS.map(
    (c) => `<th><div class="th-label">${c.label}</div></th>`
  ).join("")}</tr>`;
}

function renderProfs() {
  renderProfsHead();
  const q = searchProf.value.trim().toLowerCase();

  let rows = teachersActuales().map((t) => {
    const m = getMetric(t.name);
    const mats = teacherMaterias(t.name);
    return {
      ...t,
      ...m,
      _grupo: t.grupos[0] || "",
      _semestre: t.semestres[0] || 99,
      _materia: t.materias[0] || "",
      _imparte: mats.filter((x) => x.active).length,
      _yano: mats.filter((x) => !x.active).length,
    };
  });

  // Con el filtro de materias puesto, un maestro sin ninguna que encaje no
  // aporta nada: saldría como una fila vacía. Mejor no listarlo.
  if (profMats === "imparte") rows = rows.filter((r) => r._imparte > 0);
  if (profMats === "yano") rows = rows.filter((r) => r._yano > 0);

  if (q) {
    rows = rows.filter((r) =>
      r.name.toLowerCase().includes(q) ||
      r.materias.some((m) => m.toLowerCase().includes(q))
    );
  }

  // P16: filtro por turno (derivado de los grupos del maestro)
  if (profTurno !== "ambos") {
    rows = rows.filter((r) => turnosDeGrupos(r.grupos).has(profTurno));
  }
  document.getElementById("profCount").textContent = rows.length;
  const txt = document.getElementById("profCountTxt");
  if (txt) {
    txt.textContent =
      profMats === "imparte" ? "maestros que dan clase este periodo"
      : profMats === "yano" ? "maestros con materias que ya no imparten"
      : q || profTurno !== "ambos" ? "maestros que encajan" : "maestros en total";
  }

  const { key, dir } = profSort;
  rows.sort((a, b) => {
    // Texto (alfabético): name, grupo, materia
    if (key === "name" || key === "grupo" || key === "materia") {
      const fld = key === "name" ? "name" : (key === "grupo" ? "_grupo" : "_materia");
      return dir === "asc" ? a[fld].localeCompare(b[fld]) : b[fld].localeCompare(a[fld]);
    }
    // Semestre (numérico simple)
    if (key === "semestre") {
      return dir === "asc" ? a._semestre - b._semestre : b._semestre - a._semestre;
    }
    // Cuántas materias imparte / cuántas ya no. A igualdad, alfabético, para
    // que la lista no baile entre repintados.
    if (key === "imparte" || key === "yano") {
      const fld = key === "imparte" ? "_imparte" : "_yano";
      return (dir === "asc" ? a[fld] - b[fld] : b[fld] - a[fld]) || a.name.localeCompare(b.name);
    }
    // Métricas numéricas
    const av = a[key] === "" || a[key] == null ? null : Number(a[key]);
    const bv = b[key] === "" || b[key] == null ? null : Number(b[key]);
    if (av == null && bv == null) return 0;
    if (av == null) return 1;
    if (bv == null) return -1;
    return dir === "asc" ? av - bv : bv - av;
  });

  if (!rows.length) {
    // Decir por qué está vacío. "Solo las que ya no" sale vacío hasta que
    // marques tu primera materia en rojo, y eso hay que explicarlo.
    const motivo = q || profTurno !== "ambos"
      ? `Ningún maestro encaja con lo que buscaste.`
      : profMats === "yano"
      ? `Ningún maestro tiene materias que haya dejado de dar.`
      : `No hay maestros para mostrar.`;
    profsBody.innerHTML = `<tr><td colspan="${PROF_COLS.length}">
        <div class="drop-empty big">${motivo}</div></td></tr>`;
    return;
  }

  profsBody.innerHTML = rows.map((r) => `
    <tr>
      <td>
        <div class="pname"><a href="#" class="prof-link" data-prof="${esc(r.name)}">${esc(r.name)}</a>${turnoBadges(r.grupos)}${carreraBadges(r.name)}</div>
        ${matsCellHTML(r.name)}
      </td>
      <td>${metricCell(r.calidad, "cal")}</td>
      <td>${metricCell(r.recomiendan, "rec")}</td>
      <td>${metricCell(r.dificultad, "dif")}</td>
    </tr>`).join("");

  profsBody.querySelectorAll(".prof-link").forEach((a) => {
    a.onclick = (e) => { e.preventDefault(); showProfDetail(a.dataset.prof); };
  });
}

// Celda de materias: etiquetas verde (la da este periodo) y roja (ya no; dice
// el último periodo en que la dio). Solo informan: no se pueden cambiar.
function matsCellHTML(name) {
  const tags = matsVisibles(name).map((x) =>
    `<span class="mtag ${x.active ? "on" : "off"}" title="${esc(matTitulo(x))}">${esc(titleCase(x.mat))}${x.active ? "" : ` <small>${esc(x.periodo || "")}</small>`}</span>`
  ).join("");
  return `<div class="pmats">${tags}</div>`;
}

// P5: paleta de 6 colores aplicada a las 3 métricas
function metricColor(val, kind) {
  if (val === "" || val == null) return "na";
  const n = Number(val);
  if (!Number.isFinite(n)) return "na";
  if (kind === "cal") {
    if (n >= 9) return "g1"; if (n >= 8) return "g2"; if (n >= 7) return "y1";
    if (n >= 6) return "o1"; if (n >= 4.9) return "r1"; return "r2";
  }
  if (kind === "rec") {
    if (n >= 90) return "g1"; if (n >= 80) return "g2"; if (n >= 70) return "y1";
    if (n >= 60) return "o1"; if (n >= 50) return "r1"; return "r2";
  }
  // dificultad invertida: bajo = bueno (verde), alto = malo (rojo)
  if (n < 1) return "g1"; if (n < 2) return "g2"; if (n < 3) return "y1";
  if (n < 4) return "o1"; if (n < 5) return "r1"; return "r2";
}

function metricCell(val, kind) {
  const cls = metricColor(val, kind);
  const has = val !== "" && val != null;
  const text = !has ? "—" : (kind === "rec" ? val + "%" : val);
  return `<span class="metric-pill ${cls}">${esc(text)}</span>`;
}

searchProf.addEventListener("input", renderProfs);

// P7+P8: dropdown único de orden
const sortProfEl = document.getElementById("sortProf");
sortProfEl.addEventListener("change", () => {
  const [key, dir] = sortProfEl.value.split("|");
  profSort = { key, dir };
  renderProfs();
});

const matsProfEl = document.getElementById("matsProf");
matsProfEl?.addEventListener("change", () => {
  profMats = matsProfEl.value;
  renderProfs();
});

// ----- Vista detalle de maestro (full-page dentro de pestaña Maestros) -----
const profDetailEl  = document.getElementById("profDetail");
const profsListWrap = document.getElementById("profsListWrap");
const profsPaneHead = document.querySelector("#pane-maestros .pane-head");
let currentProfDetail = null; // maestro cuyo detalle está abierto (para repintar al cargar el CSV)

function ofertasDeMaestro(name) {
  // Siempre las tres carreras: un maestro da donde da, y su horario real es el
  // conjunto. Cruce por norm() porque los nombres pueden venir con o sin acentos
  // y aquí llegan con ellos (HURTADO AVILÉS vs HURTADO AVILES).
  const sched = typeof SCHEDULE !== "undefined" ? SCHEDULE : [];
  const nn = norm(name);
  return sched.filter((e) => norm(e.profesor) === nn);
}

// Rejilla semanal del maestro: misma estructura que la del alumno,
// con TODOS los bloques 07:00–21:30 + recesos 10:00–10:30 y 18:00–18:30.
function renderProfSchedGrid(ofertas) {
  // Colores estables por materia/grupo
  const colorOf = new Map();
  const keyOf = (o) => `${o.materia}__${o.grupo}`;
  ofertas.forEach((o) => {
    const k = keyOf(o);
    if (!colorOf.has(k)) colorOf.set(k, SCHED_COLORS[colorOf.size % SCHED_COLORS.length]);
  });

  const blockIdx = (ini) => TIME_BLOCKS.findIndex((b) => b.ini === ini);

  // Recortar a los bloques realmente ocupados
  const occupied = new Set();
  ofertas.forEach((o) => (o.sesiones || []).forEach((s) => {
    const k = blockIdx(s.ini);
    if (k >= 0) occupied.add(k);
  }));
  if (occupied.size === 0) {
    return `<div class="drop-empty">Sin sesiones en bloques estándar.</div>`;
  }
  const minIdx = Math.min(...occupied);
  const maxIdx = Math.max(...occupied);

  let html = `<table class="sched-table"><thead><tr>
    <th class="sched-hora">Hora</th>
    ${DIAS.map((d) => `<th>${d.toUpperCase()}</th>`).join("")}
  </tr></thead><tbody>`;

  for (let i = minIdx; i <= maxIdx; i++) {
    const b = TIME_BLOCKS[i];
    html += `<tr><th class="sched-hora">${b.ini}<br>${b.fin}</th>`;
    DIAS.forEach((d) => {
      const items = [];
      ofertas.forEach((o) => {
        (o.sesiones || []).forEach((s) => {
          if (s.dia === d && s.ini === b.ini) items.push(o);
        });
      });
      const conflict = items.length > 1;
      if (items.length === 0) {
        html += `<td class="sched-empty"></td>`;
      } else {
        const inner = items.map((o) => {
          const c = colorOf.get(keyOf(o));
          const salonEd = `Ed.${esc(String(o.edificio || "—"))} · S.${esc(String(o.salon || "—"))}`;
          return `<div class="sched-cell" style="background:${c.bg};color:${c.fg};border-color:${c.bd}" title="${esc(titleCase(o.materia))} · ${esc(o.grupo)} · ${salonEd}">
            <div class="sched-mat">${esc(shortMat(o.materia))}</div>
            <div class="sched-meta"><b>${esc(o.grupo)}</b> · ${salonEd}</div>
          </div>`;
        }).join("");
        html += `<td class="${conflict ? "sched-conflict" : ""}">${inner}</td>`;
      }
    });
    html += `</tr>`;
    if (b.ini === "08:30" && i < maxIdx) {
      html += `<tr class="sched-receso"><td colspan="${DIAS.length + 1}">☕ Receso 10:00 – 10:30</td></tr>`;
    }
    if (b.ini === "16:30" && i < maxIdx) {
      html += `<tr class="sched-receso"><td colspan="${DIAS.length + 1}">☕ Receso 18:00 – 18:30</td></tr>`;
    }
  }
  html += `</tbody></table>`;
  return html;
}

const DIAS_ORDEN = { Lun:1, Mar:2, Mie:3, Mié:3, Jue:4, Vie:5, Sab:6, Sáb:6, Dom:7 };

function showProfDetail(name) {
  // Asegura que estemos en la pestaña Maestros
  document.querySelectorAll(".tab").forEach((b) =>
    b.classList.toggle("active", b.dataset.tab === "maestros"));
  document.querySelectorAll(".tabpane").forEach((p) =>
    p.classList.toggle("active", p.id === "pane-maestros"));

  if (profsPaneHead) profsPaneHead.hidden = true;
  if (profsListWrap) profsListWrap.hidden = true;
  profDetailEl.hidden = false;
  currentProfDetail = name;

  const m = getMetric(name);
  const man = manualMetricFor(name);
  const link = man && man.link ? man.link : "";

  const ofertas = ofertasDeMaestro(name);
  const turnos = new Set(ofertas.map((o) => turnoDeGrupo(o.grupo)).filter(Boolean));
  const turnoLabel = turnos.size === 0 ? "—"
    : turnos.has("M") && turnos.has("V") ? "Mixto (M + V)"
    : turnos.has("M") ? "☀️ Matutino" : "🌙 Vespertino";

  const tablaHTML = ofertas.length === 0
    ? `<div class="drop-empty">Este maestro no tiene clases registradas este semestre.</div>`
    : renderProfSchedGrid(ofertas);

  profDetailEl.innerHTML = `
    <div class="pd-head">
      <button class="btn pd-back" id="profBack">← Volver a la lista</button>
      <div class="pd-title-wrap">
        <h2 class="pd-title">${esc(name)}</h2>
        <div class="pd-sub">
          <span class="pd-turno">${turnoLabel}</span>
          ${link ? `· <a href="${esc(link)}" target="_blank" rel="noopener" class="pd-link">🔗 Fuente</a>` : ""}
          ${man ? `<span class="pd-tag manual" title="Calificaciones de MisProfesores, con link a su ficha">manual</span>` : `<span class="pd-tag oficial" title="Calificaciones de MisProfesores">oficial</span>`}
        </div>
        <div class="pd-sub" id="pdCedula"></div>
      </div>
    </div>

    <h3 class="pd-section">Calificaciones de MisProfesores</h3>
    <div class="pd-metrics">
      <div class="pd-m"><div class="pd-m-label">Calidad</div>${metricCell(m.calidad, "cal")}</div>
      <div class="pd-m"><div class="pd-m-label">Lo recomiendan</div>${metricCell(m.recomiendan, "rec")}</div>
      <div class="pd-m"><div class="pd-m-label">Dificultad</div>${metricCell(m.dificultad, "dif")}</div>
    </div>

    <div id="pdComentarios"></div>

    <h3 class="pd-section">Materias por periodo (26/2 → 27/1) <span class="pd-solo">26/2 solo ISC</span></h3>
    ${periodoMatsHTML(name)}

    <h3 class="pd-section">Horario semanal</h3>
    ${tablaHTML}

    <h3 class="pd-section">Fuentes</h3>
    ${fuentesHTML(link)}
  `;

  document.getElementById("profBack").onclick = hideProfDetail;
  // Cédula y comentarios: los trae comentarios.js de api/profesor.php.
  if (typeof pintarComentarios === "function") pintarComentarios(name);
  window.scrollTo({ top: 0, behavior: "smooth" });
}

// Materias que imparte un profesor en un periodo del HISTORIAL (por nombre normalizado)
function materiasDeProfPeriodo(name, periodo) {
  const map = new Map(); // materiaNorm -> { materia, grupos:Set }
  if (typeof HISTORIAL === "undefined" || !HISTORIAL[periodo]) return map;
  const nn = norm(name);
  HISTORIAL[periodo].forEach((o) => {
    if (norm(o.profesor) !== nn) return;
    const k = norm(o.materia);
    if (!map.has(k)) map.set(k, { materia: o.materia, grupos: new Set() });
    map.get(k).grupos.add(o.grupo);
  });
  return map;
}

// Etiquetas verde (imparte en 27/1) / rojo (impartía en 26/2, ya no) para un maestro
function periodoMatsHTML(name) {
  // Esta sección es la única parte de la ficha que necesita historial.js (190 KB).
  // Se pide al abrir la ficha y la ficha se repinta cuando llega.
  if (typeof HISTORIAL === "undefined") {
    cargarDato("historial.js").then(repintarActiva).catch(() => {});
    return `<div class="drop-empty">Cargando periodos…</div>`;
  }
  const ant = materiasDeProfPeriodo(name, "2026/2");
  const act = materiasDeProfPeriodo(name, "2027/1");
  if (ant.size === 0 && act.size === 0) {
    // Ojo: el historial guardado es solo de ISC. Para un maestro que únicamente
    // da IA o LCD esto sale vacío, y eso NO significa que no haya dado clase.
    return `<div class="drop-empty">Sin registro en 2026/2 ni 2027/1.
      El historial guardado es solo de ISC, así que un maestro que solo da IA o
      Ciencia de Datos aparece vacío aquí.</div>`;
  }
  // grupos con su etiqueta de cupo (vigente para 27/1, histórico para 26/2)
  const gruposConCupo = (v, historico) =>
    [...v.grupos].sort().map((g) => {
      const c = historico ? cupoHistDe(g, v.materia, "2026/2") : cupoDe(g, v.materia);
      const tag = historico ? cupoHistTag(c) : cupoBadge(g, v.materia);
      return `<span class="permat-grupo">${esc(g)}${tag ? " " + tag : ""}</span>`;
    }).join("");

  const chips = [];
  [...act.values()].forEach((v) => {
    chips.push(`<span class="permat on">${esc(titleCase(v.materia))}<span class="permat-grupos">${gruposConCupo(v, false)}</span></span>`);
  });
  [...ant.keys()].filter((k) => !act.has(k)).forEach((k) => {
    const v = ant.get(k);
    chips.push(`<span class="permat off">${esc(titleCase(v.materia))}<span class="permat-grupos">${gruposConCupo(v, true)}</span></span>`);
  });
  return `<div class="permat-legend"><span class="permat on">Imparte en 27/1 · cupo libre</span><span class="permat off">Ya no (26/2) · inscritos/cupo</span></div>
    <div class="permats">${chips.join("")}</div>`;
}

// Nombre legible del sitio a partir del dominio del link
function siteLabel(link) {
  try {
    const host = new URL(link).hostname.replace(/^www\./, "");
    if (/misprofesores/i.test(host)) return "MisProfesores.com";
    return host;
  } catch (e) { return "Fuente"; }
}

// Apartado "Fuentes": link completo y clickeable del maestro
function fuentesHTML(link) {
  if (!link) {
    return `<div class="drop-empty">Sin fuente registrada para este maestro.</div>`;
  }
  return `<ul class="pd-fuentes">
    <li>
      <a href="${esc(link)}" target="_blank" rel="noopener" class="pd-fuente">
        <span class="pd-fuente-ico">🔗</span>
        <span class="pd-fuente-txt">
          <b>${esc(siteLabel(link))}</b>
          <span class="pd-fuente-url">${esc(link)}</span>
        </span>
        <span class="pd-fuente-go">Abrir ↗</span>
      </a>
    </li>
  </ul>`;
}

function hideProfDetail() {
  currentProfDetail = null;
  profDetailEl.hidden = true;
  profDetailEl.innerHTML = "";
  if (profsPaneHead) profsPaneHead.hidden = false;
  if (profsListWrap) profsListWrap.hidden = false;
}

// Al cambiar de pestaña vía botones, si salimos de maestros, reset del detalle
tabsEl.querySelectorAll(".tab").forEach((btn) => {
  const prev = btn.onclick;
  btn.addEventListener("click", () => {
    if (btn.dataset.tab !== "maestros") hideProfDetail();
  });
});

// P16: filtro por turno (Ambos / Matutino / Vespertino)
document.getElementById("turnoFilter").addEventListener("click", (e) => {
  const btn = e.target.closest(".turno-btn");
  if (!btn) return;
  profTurno = btn.dataset.turno;
  document.querySelectorAll("#turnoFilter .turno-btn").forEach((b) =>
    b.classList.toggle("active", b === btn));
  renderProfs();
});


