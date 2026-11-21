// ============================================================
//  VENTANA DE LA MATERIA (Fase 5)
// ============================================================
// El botón ⓘ de cada materia (Mi avance y Optativas) abre una ventana con
// sus datos del plan, la seriación y, del programa sintético oficial, el
// propósito y las unidades, más el botón al PDF.
//
// Decisión del usuario (2026-11-20): la descripción es el propósito y los
// temas TAL CUAL el PDF. Para los PDFs escaneados (sin texto) hay una
// descripción investigada, marcada con su fuente: no es la oficial.
//
// Los textos salen de api/materias.php, que se pide la primera vez que
// abres una materia (lazy.js: "materias.js").

const materiaEl = document.getElementById("materia");
const materiaTitEl = document.getElementById("materiaTit");
const materiaBodyEl = document.getElementById("materiaBody");

const SEM_ORD = ["1.er", "2.º", "3.er", "4.º", "5.º", "6.º", "7.º", "8.º"];

// clave → materia del plan activo (obligatorias y optativas que se ofrecen)
function materiaDePlan(clave) {
  return PLAN_ACTIVO.materias.find((m) => m.clave === clave)
    || PLAN_ACTIVO.optativas.find((m) => m.clave === clave)
    || null;
}

// Botón para poner junto al nombre de una materia. Sin clave (un lugar de
// optativa todavía sin elegir) no hay nada que abrir.
function botonMateria(clave) {
  if (!clave) return "";
  return `<button class="infoBtn" type="button" data-materia="${esc(clave)}"
    title="Propósito, temas y programa (PDF)" aria-label="Ver la materia ${esc(clave)}">ⓘ</button>`;
}

function listaMaterias(claves) {
  return claves.map((c) => {
    const m = materiaDePlan(c);
    return `<button class="mat-link" type="button" data-materia="${esc(c)}">${esc(m ? m.nom : c)}</button>`;
  }).join("");
}

function materiaHTML(clave) {
  const m = materiaDePlan(clave);
  const info = (typeof MATERIAS_INFO !== "undefined" && MATERIAS_INFO[clave]) || {};
  const req = (PLAN_ACTIVO.seriacion[clave] || []);
  const dePara = Object.entries(PLAN_ACTIVO.seriacion).filter(([, rs]) => rs.includes(clave)).map(([c]) => c);

  const [proposito, temasTxt] = String(info.desc || "").split("\n\n");
  const temas = (temasTxt || "").split("\n").filter(Boolean);

  const datos = m ? `
    <div class="mat-datos">
      <span><b>${esc(clave)}</b></span>
      <span>${SEM_ORD[m.sem - 1]} semestre</span>
      <span>${fmt(m.cr)} créditos</span>
      <span>${m.ua} UA</span>
      ${m.ht != null ? `<span>${fmt(m.ht)} h teoría · ${fmt(m.hp)} h práctica por semana</span>` : ""}
      <span>${PLAN_ACTIVO.optativas.some((o) => o.clave === clave) ? "Optativa" : "Obligatoria"}</span>
    </div>` : `<div class="mat-datos"><span><b>${esc(clave)}</b></span></div>`;

  const seriacion = (req.length || dePara.length) ? `
    <div class="mat-seriacion">
      ${req.length ? `<div><span class="mat-etq">Te conviene llevar antes</span>${listaMaterias(req)}</div>` : ""}
      ${dePara.length ? `<div><span class="mat-etq">Es antecedente de</span>${listaMaterias(dePara)}</div>` : ""}
    </div>` : "";

  let cuerpo;
  if (typeof MATERIAS_INFO === "undefined") {
    cuerpo = `<div class="drop-empty">Cargando el programa…</div>`;
  } else if (!info.desc) {
    cuerpo = `<div class="drop-empty">Todavía no tenemos el programa de esta materia.</div>`;
  } else {
    cuerpo = `
      <h3 class="mat-sec">Propósito</h3>
      <p class="mat-prop">${esc(proposito)}</p>
      ${temas.length ? `<h3 class="mat-sec">Temas</h3><ol class="mat-temas">${temas.map((t) => {
        const [, num, tema] = t.match(/^([IVX]+)\.\s*(.*)$/) || [null, "", t];   // "II. Modelo…" → "II" y "Modelo…"
        return `<li><span>${esc(num)}</span>${esc(tema)}</li>`;
      }).join("")}</ol>` : ""}
      <p class="mat-fuente${info.fuente ? " investigada" : ""}">${info.fuente
        ? `⚠️ <b>Descripción orientativa:</b> el PDF oficial es un escaneo sin texto, así que esto no sale de él. Fuente: ${fuenteHTML(info.fuente)} El PDF es la referencia.`
        : "Tal cual el programa sintético oficial del IPN (plan 2020)."}</p>`;
  }

  const pdf = info.pdf
    ? `<a class="btn btn-primary mat-pdf" href="${esc(info.pdf)}" target="_blank" rel="noopener">📄 Ver programa oficial (PDF)</a>`
    : (typeof MATERIAS_INFO !== "undefined" ? `<p class="cuenta-nota">Sin PDF del programa todavía.</p>` : "");

  return datos + seriacion + cuerpo + pdf;
}

// La fuente puede traer una dirección: se vuelve enlace.
function fuenteHTML(fuente) {
  return esc(fuente).replace(/(https?:\/\/[^\s<]+)/g, (u) => `<a href="${u}" target="_blank" rel="noopener">${u}</a>`);
}

let materiaAbierta = null;
function abrirMateria(clave) {
  materiaAbierta = clave;
  const m = materiaDePlan(clave);
  materiaTitEl.textContent = m ? m.nom : clave;
  materiaBodyEl.innerHTML = materiaHTML(clave);
  abrirModal(materiaEl);
  if (typeof MATERIAS_INFO === "undefined") {
    cargarDato("materias.js")
      .then(() => { if (materiaAbierta === clave && !materiaEl.hidden) materiaBodyEl.innerHTML = materiaHTML(clave); })
      .catch(() => { materiaBodyEl.querySelector(".drop-empty").textContent = "No se pudo cargar el programa. Revisa tu conexión."; });
  }
}

// Un solo escucha para toda la página: los botones ⓘ se repintan seguido.
document.addEventListener("click", (e) => {
  const b = e.target.closest("[data-materia]");
  if (!b) return;
  e.preventDefault();
  e.stopPropagation();
  abrirMateria(b.dataset.materia);
}, true);

document.getElementById("materiaCerrar").addEventListener("click", () => cerrarModal(materiaEl));
materiaEl.addEventListener("click", (e) => { if (e.target === materiaEl) cerrarModal(materiaEl); });
document.addEventListener("keydown", (e) => { if (e.key === "Escape") cerrarModal(materiaEl); });
