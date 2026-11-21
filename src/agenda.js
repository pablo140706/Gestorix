// ============================================================
//  AGENDA (Fase 5) — recordatorios en la pestaña Calendario
// ============================================================
// "12 nov, 10:00, Examen de Bases de Datos". Decisiones del usuario
// (CLAUDE.md §7, 2026-11-20):
//   · solo con cuenta (se guardan en la base: api/agenda.php);
//   · se agregan tocando un día del calendario; arriba, "Próximos";
//   · la hora es opcional: sin hora = todo el día;
//   · los que ya pasaron se quedan, en gris, hasta que los borres;
//   · solo se ven en el calendario: no mandan avisos.

let AGENDA = null;                 // null = sin cuenta o sin cargar; si no, la lista
const agendaEl = document.getElementById("agenda");
const agendaTitEl = document.getElementById("agendaTit");
const agendaBodyEl = document.getElementById("agendaBody");
const DIAS_SEM = ["dom", "lun", "mar", "mié", "jue", "vie", "sáb"];

const isoDe = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
const hoyIso = () => isoDe(calHoy());
const fechaLarga = (iso) => { const d = calFecha(iso); return `${DIAS_SEM[d.getDay()]} ${d.getDate()} ${CAL_MESES[d.getMonth()]} ${d.getFullYear()}`; };
const fechaCorta = (iso) => { const d = calFecha(iso); return `${DIAS_SEM[d.getDay()]} ${d.getDate()} ${CAL_MESES[d.getMonth()]}`; };

// Lo usa calMesHtml (calendario-ui.js) para el puntito de cada día.
function recordatoriosDel(iso) {
  return AGENDA ? AGENDA.filter((r) => r.fecha === iso) : [];
}

async function cargarAgenda() {
  if (!USUARIO) { AGENDA = null; pintarAgenda(); return; }
  try {
    AGENDA = (await apiCuenta("agenda.php")).recordatorios;
  } catch (e) {
    AGENDA = null;
  }
  pintarAgenda();
}

// "Próximos" arriba del calendario, y repintar los puntitos de los días.
function pintarAgenda() {
  const caja = document.getElementById("calAgenda");
  if (caja) {
    if (!USUARIO) {
      caja.innerHTML = `<div class="ag-vacia">📌 <a href="#" data-ag="entrar">Entra a tu cuenta</a> para apuntar
        recordatorios (exámenes, entregas…) en el calendario. Solo los ves tú.</div>`;
    } else {
      const hoy = hoyIso();
      const prox = (AGENDA || []).filter((r) => r.fecha >= hoy).slice(0, 8);
      caja.innerHTML = `
        <div class="ag-cab">
          <h3 class="pd-section">Tus próximos recordatorios</h3>
          <button class="btn" data-ag="nuevo">+ Nuevo</button>
        </div>
        ${prox.length ? `<ul class="ag-lista">${prox.map((r) => `
          <li><button class="ag-item" data-ag="editar" data-id="${r.id}">
            <span class="ag-fecha">${esc(fechaCorta(r.fecha))}${r.fecha === hoy ? " · <b>hoy</b>" : ""}</span>
            <span class="ag-hora">${r.hora ? esc(r.hora) : "todo el día"}</span>
            <span class="ag-tit">${esc(r.titulo)}</span>
            ${r.materia ? `<span class="ag-mat">${esc(r.materia.nombre)}</span>` : ""}
          </button></li>`).join("")}</ul>`
          : `<div class="ag-vacia">No tienes recordatorios próximos. Toca un día del calendario para agregar uno.</div>`}`;
    }
  }
  if (document.getElementById("pane-calendario")?.classList.contains("active")) renderCalendario();
}

// ---------- ventana ----------
function opcionesMateria(sel) {
  const todas = [...PLAN_ACTIVO.materias, ...PLAN_ACTIVO.optativas].sort((a, b) => a.sem - b.sem || a.nom.localeCompare(b.nom));
  return `<option value="">— Ninguna —</option>` + todas.map((m) =>
    `<option value="${esc(m.clave)}"${m.clave === sel ? " selected" : ""}>${esc(m.nom)} (${m.sem}.º)</option>`).join("");
}

function formRecordatorioHTML(r, fecha) {
  return `
    <form class="cuenta-form ag-form" data-id="${r ? r.id : ""}">
      <div class="ag-fila">
        <label class="campo">Fecha<input name="fecha" type="date" required value="${esc(r ? r.fecha : fecha)}"></label>
        <label class="campo">Hora <small>(opcional)</small><input name="hora" type="time" value="${esc(r && r.hora ? r.hora : "")}"></label>
      </div>
      <label class="campo">Título<input name="titulo" maxlength="100" required placeholder="Examen de Bases de Datos" value="${esc(r ? r.titulo : "")}"></label>
      <label class="campo">Materia <small>(opcional)</small><select name="materia">${opcionesMateria(r && r.materia ? r.materia.clave : "")}</select></label>
      <label class="campo">Nota <small>(opcional)</small><textarea name="nota" maxlength="500" rows="2">${esc(r && r.nota ? r.nota : "")}</textarea></label>
      <div class="cuenta-msg" role="status"></div>
      <div class="com-form-botones">
        <button class="btn btn-primary" type="submit">${r ? "Guardar cambios" : "Guardar"}</button>
        ${r ? `<button class="btn btn-danger" type="button" data-ag="borrar" data-id="${r.id}">Borrar</button>` : ""}
      </div>
    </form>`;
}

// Abre la ventana de un día (con sus recordatorios y uno nuevo) o la de editar uno.
function abrirAgenda({ fecha, id } = {}) {
  if (!USUARIO) {
    agendaTitEl.textContent = fecha ? fechaLarga(fecha) : "Recordatorios";
    agendaBodyEl.innerHTML = `<p class="cuenta-nota">Para apuntar recordatorios en el calendario necesitas una cuenta:
        así se guardan y los ves desde cualquier navegador. Solo los ves tú.</p>
      <button class="btn btn-primary" data-ag="entrar">Entrar o crear cuenta</button>`;
    abrirModal(agendaEl);
    return;
  }
  const r = id ? (AGENDA || []).find((x) => x.id === Number(id)) : null;
  const dia = r ? r.fecha : (fecha || hoyIso());
  agendaTitEl.textContent = r ? "Editar recordatorio" : fechaLarga(dia);
  const delDia = r ? [] : recordatoriosDel(dia);
  const pasado = dia < hoyIso();
  agendaBodyEl.innerHTML = (delDia.length ? `
      <ul class="ag-lista ag-dia">${delDia.map((x) => `
        <li><button class="ag-item${pasado ? " pasado" : ""}" data-ag="editar" data-id="${x.id}">
          <span class="ag-hora">${x.hora ? esc(x.hora) : "todo el día"}</span>
          <span class="ag-tit">${esc(x.titulo)}</span>
          ${x.materia ? `<span class="ag-mat">${esc(x.materia.nombre)}</span>` : ""}
          ${x.nota ? `<span class="ag-nota">${esc(x.nota)}</span>` : ""}
        </button></li>`).join("")}</ul>
      <h3 class="mat-sec">Agregar otro</h3>` : "") + formRecordatorioHTML(r, dia);
  abrirModal(agendaEl);
  if (!delDia.length) agendaBodyEl.querySelector(r ? "[name=titulo]" : "[name=titulo]").focus();
}

// ---------- eventos ----------
document.getElementById("calMeses")?.addEventListener("click", (e) => {
  const d = e.target.closest(".cd[data-fecha]");
  if (d) abrirAgenda({ fecha: d.dataset.fecha });
});

document.addEventListener("click", async (e) => {
  const b = e.target.closest("[data-ag]");
  if (!b) return;
  e.preventDefault();
  const que = b.dataset.ag;
  if (que === "entrar") { cerrarModal(agendaEl); abrirCuenta("entrar"); return; }
  if (que === "nuevo") { abrirAgenda({ fecha: hoyIso() }); return; }
  if (que === "editar") { abrirAgenda({ id: b.dataset.id }); return; }
  if (que === "borrar") {
    if (!confirm("¿Borrar este recordatorio?")) return;
    try {
      await apiCuenta("agenda.php", { accion: "borrar", id: Number(b.dataset.id) });
      cerrarModal(agendaEl);
      cargarAgenda();
    } catch (err) { alert(err.message); }
  }
});

agendaBodyEl.addEventListener("submit", async (e) => {
  e.preventDefault();
  const form = e.target;
  const msg = form.querySelector(".cuenta-msg");
  const boton = form.querySelector("button[type=submit]");
  const v = Object.fromEntries(new FormData(form));
  const datos = { accion: "guardar", fecha: v.fecha, hora: v.hora, titulo: v.titulo, materia: v.materia, nota: v.nota };
  if (form.dataset.id) datos.id = Number(form.dataset.id);
  boton.disabled = true;
  try {
    await apiCuenta("agenda.php", datos);
    cerrarModal(agendaEl);
    cargarAgenda();
  } catch (err) {
    mostrarMsg(msg, err.message, true);
    boton.disabled = false;
  }
});

document.getElementById("agendaCerrar").addEventListener("click", () => cerrarModal(agendaEl));
agendaEl.addEventListener("click", (e) => { if (e.target === agendaEl) cerrarModal(agendaEl); });
document.addEventListener("keydown", (e) => { if (e.key === "Escape") cerrarModal(agendaEl); });

// Al cargar: si ya hay sesión, trae los recordatorios; si no, el aviso.
if (USUARIO) cargarAgenda(); else pintarAgenda();
