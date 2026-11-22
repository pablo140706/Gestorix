// ============================================================
//  COMENTARIOS Y MODERACIÓN (Fase 4) — dentro de la ficha del maestro
// ============================================================
// La ficha (maestros.js) deja un hueco <div id="pdComentarios"> y llama a
// pintarComentarios(nombre). Aquí se pide a api/profesor.php la cédula, las
// materias que da y los comentarios, y se pinta todo.
//
// Reglas (CLAUDE.md §6):
//   · leer: cualquiera; comentar y reportar: con cuenta y sin suspensión;
//   · escalas de MisProfesores, pero NUNCA promediadas con las suyas: el
//     resumen de aquí va aparte, con su propio título;
//   · máximo 500 caracteres; rúbrica opcional que suma 100 %;
//   · el autor edita o borra en las primeras 24 h;
//   · moderadores: ocultar / mostrar, descartar reportes, suspender 1, 7 o
//     30 días y banear. Todo con motivo (queda en la bitácora).

const MOTIVOS_REPORTE = [
  "Ataque personal", "Acusación sin sustento", "Datos personales",
  "Odio o amenaza", "Spam o no habla de la clase", "Otro",
];
const TEXTO_MAX = 500;
const RUBRICA_MAX = 6;

let FICHA = null;          // lo último que respondió api/profesor.php
let fichaNombre = null;    // de quién es

async function pintarComentarios(nombre) {
  fichaNombre = nombre;
  const caja = document.getElementById("pdComentarios");
  const ced = document.getElementById("pdCedula");
  if (!caja) return;
  caja.innerHTML = `<div class="drop-empty">Cargando comentarios…</div>`;
  try {
    const d = await apiCuenta("profesor.php?nombre=" + encodeURIComponent(nombre));
    if (fichaNombre !== nombre) return;              // ya abrieron otra ficha
    FICHA = d;
    if (ced) ced.innerHTML = cedulaHTML(d.profesor);
    caja.innerHTML = comentariosHTML(d);
  } catch (e) {
    if (fichaNombre !== nombre) return;
    caja.innerHTML = `<div class="drop-empty">No se pudieron cargar los comentarios: ${esc(e.message)}</div>`;
  }
}

// Repinta la ficha abierta (al entrar o salir de la cuenta, o tras una acción).
function refrescarComentarios() {
  if (typeof currentProfDetail !== "undefined" && currentProfDetail) pintarComentarios(currentProfDetail);
}

// Cédulas profesionales: una por grado (tabla cedula), del más alto al más bajo.
const NIVEL_CEDULA = {
  doctorado: "Doctorado", especialidad: "Especialidad", maestria: "Maestría",
  ingenieria: "Ingeniería", licenciatura: "Licenciatura",
};
function cedulaHTML(p) {
  const rnp = `<a href="https://www.cedulaprofesional.sep.gob.mx/" target="_blank" rel="noopener"
    title="Consúltalas en el Registro Nacional de Profesionistas (SEP)">RNP ↗</a>`;
  if (!p.cedulas || !p.cedulas.length) return `<span class="pd-cedula falta">Sin cédula registrada · ${rnp}</span>`;
  return `<span class="pd-cedula">Cédulas: ${p.cedulas.map((c) =>
    `<span class="pd-ced"><b>${esc(NIVEL_CEDULA[c.nivel] || c.nivel)}</b> ${esc(c.numero)}</span>`).join("")} ${rnp}</span>`;
}

// ---------- pintar ----------
function comentariosHTML(d) {
  const r = d.resumen;
  const resumen = r.comentarios === 0 ? "" : `
    <div class="pd-metrics com-resumen">
      <div class="pd-m"><div class="pd-m-label">Calidad</div>${metricCell(r.calidad, "cal")}</div>
      <div class="pd-m"><div class="pd-m-label">Lo recomiendan</div>${metricCell(r.recomienda, "rec")}</div>
      <div class="pd-m"><div class="pd-m-label">Dificultad</div>${metricCell(r.dificultad, "dif")}</div>
    </div>`;
  const lista = d.comentarios.length
    ? d.comentarios.map(comentarioHTML).join("")
    : `<div class="drop-empty">Todavía nadie comenta sobre este maestro.${d.yo.puede_comentar ? " Sé el primero." : ""}</div>`;
  return `
    <h3 class="pd-section">Comentarios de alumnos en Gestorix
      <span class="com-cuenta">${r.comentarios} ${r.comentarios === 1 ? "comentario" : "comentarios"}</span></h3>
    <p class="com-nota">Promedio de los comentarios de aquí. Va aparte de las calificaciones de
      MisProfesores de arriba: no se mezclan.</p>
    ${resumen}
    ${formularioOEntrada(d)}
    <div class="com-lista">${lista}</div>`;
}

function formularioOEntrada(d) {
  if (!d.yo.sesion) {
    return `<div class="com-entrar"><a href="#" data-com="entrar">Entra o crea tu cuenta</a> para comentar.
      Solo se muestra tu alias.</div>`;
  }
  if (!d.yo.puede_comentar) {
    return `<div class="com-entrar suspendido">Tu cuenta está suspendida hasta el ${esc(d.yo.suspendido_hasta)}:
      mientras tanto no puedes comentar ni reportar.</div>`;
  }
  if (!d.materias.length) {
    return `<div class="com-entrar">Este maestro no tiene materias registradas, así que todavía no se le puede comentar.</div>`;
  }
  return `<button class="btn btn-primary com-nuevo" data-com="nuevo">✍️ Escribir un comentario</button>
    <div class="com-form-hueco" id="comFormNuevo"></div>`;
}

function comentarioHTML(c) {
  const yo = FICHA.yo;
  // Anónimo: su nombre al azar, marcado. Los moderadores ven también quién es.
  const autor = !c.autor ? `<i>Usuario eliminado</i>`
    : c.anonimo ? `${esc(c.autor)} <span class="com-anon">anónimo</span>${c.autor_real ? ` <small>(${esc(c.autor_real)})</small>` : ""}`
    : esc(c.autor);
  const rub = c.rubrica.length
    ? `<div class="com-rubrica">${c.rubrica.map((x) => `<span>${esc(x.concepto)} <b>${x.porcentaje} %</b></span>`).join("")}</div>`
    : "";
  const acciones = [];
  if (c.editable) {
    acciones.push(`<button class="com-acc" data-com="editar" data-id="${c.id}">Editar</button>`,
                  `<button class="com-acc peligro" data-com="borrar" data-id="${c.id}">Borrar</button>`);
  }
  if (!c.mio && yo.puede_comentar && c.estado === "visible") {
    acciones.push(c.reportado
      ? `<span class="com-acc hecho">Reportado ✓</span>`
      : `<button class="com-acc" data-com="reportar" data-id="${c.id}">Reportar</button>`);
  }
  if (yo.moderador && !c.mio) {
    acciones.push(c.estado === "visible"
      ? `<button class="com-acc mod" data-com="mod" data-accion="ocultar" data-id="${c.id}">Ocultar</button>`
      : `<button class="com-acc mod" data-com="mod" data-accion="mostrar" data-id="${c.id}">Mostrar</button>`);
    if (c.reportes > 0) {
      acciones.push(`<button class="com-acc mod" data-com="mod" data-accion="descartar" data-id="${c.id}">Descartar reportes</button>`);
    }
    if (c.autor_id && c.autor_rol !== "admin") {
      acciones.push(`<button class="com-acc mod" data-com="mod" data-accion="suspender" data-id="${c.id}">Suspender autor</button>`,
                    `<button class="com-acc mod peligro" data-com="mod" data-accion="banear" data-id="${c.id}">Banear autor</button>`);
    }
  }
  return `
    <article class="com${c.estado === "oculto" ? " oculto" : ""}" id="com-${c.id}">
      <header class="com-head">
        <b class="com-autor">${autor}</b>
        <span class="com-mat">${esc(c.materia.nombre)}</span>
        <span class="com-fecha">${esc(c.creado)}${c.editado ? ` · editado ${esc(c.editado)}` : ""}</span>
        ${c.estado === "oculto" ? `<span class="com-oculto">Oculto por moderación</span>` : ""}
        ${yo.moderador && c.reportes ? `<span class="com-reportes">${c.reportes} ${c.reportes === 1 ? "reporte" : "reportes"}</span>` : ""}
      </header>
      <div class="com-escalas">
        <span>Calidad ${metricCell(c.calidad, "cal")}</span>
        <span>Lo recomienda <b class="com-rec ${c.recomienda ? "si" : "no"}">${c.recomienda ? "Sí" : "No"}</b></span>
        <span>Dificultad ${metricCell(c.dificultad, "dif")}</span>
      </div>
      <p class="com-texto">${esc(c.texto)}</p>
      ${rub}
      ${acciones.length ? `<div class="com-acciones">${acciones.join("")}</div>` : ""}
      <div class="com-panel" id="comPanel-${c.id}"></div>
    </article>`;
}

// ---------- formulario de comentario (nuevo o editar) ----------
function opciones(desde, hasta, sel) {
  let h = "";
  for (let i = desde; i <= hasta; i++) h += `<option value="${i}"${i === sel ? " selected" : ""}>${i}</option>`;
  return h;
}

function formComentarioHTML(c) {
  const mats = FICHA.materias.map((m) =>
    `<option value="${esc(m.clave)}"${c && c.materia.clave === m.clave ? " selected" : ""}>${esc(m.nombre)}${FICHA.materias.some((x) => x !== m && x.nombre === m.nombre) ? " (" + esc(m.carrera) + ")" : ""}</option>`
  ).join("");
  const rub = (c ? c.rubrica : []).map(filaRubricaHTML).join("");
  return `
    <form class="com-form" data-id="${c ? c.id : ""}">
      <div class="com-form-fila">
        <label class="campo">Materia que te dio<select name="materia" required>${c ? "" : `<option value="">Elige…</option>`}${mats}</select></label>
        <label class="campo">Calidad <small>(0 a 10)</small><select name="calidad">${opciones(0, 10, c ? c.calidad : 8)}</select></label>
        <label class="campo">Dificultad <small>(0 a 10, bajo = fácil)</small><select name="dificultad">${opciones(0, 10, c ? c.dificultad : 5)}</select></label>
      </div>
      <fieldset class="com-si-no">
        <legend>¿Lo recomiendas?</legend>
        <label><input type="radio" name="recomienda" value="si"${c && c.recomienda ? " checked" : ""} required> Sí</label>
        <label><input type="radio" name="recomienda" value="no"${c && !c.recomienda ? " checked" : ""}> No</label>
      </fieldset>
      <label class="campo">Tu comentario
        <textarea name="texto" maxlength="${TEXTO_MAX}" rows="4" required
          placeholder="Cómo explica, cómo evalúa, qué tan exigente es, qué recomendarías…">${c ? esc(c.texto) : ""}</textarea>
        <small class="com-contador">${c ? c.texto.length : 0} / ${TEXTO_MAX}</small>
      </label>
      <div class="com-rub-edit">
        <div class="com-rub-tit">Cómo evalúa <small>(opcional: si la llenas, debe sumar 100 %)</small></div>
        <div class="com-rub-filas">${rub}</div>
        <div class="com-rub-pie">
          <button type="button" class="com-acc" data-com="rub-mas">+ Concepto</button>
          <span class="com-rub-suma"></span>
        </div>
      </div>
      <label class="com-anonimo"><input type="checkbox" name="anonimo"${c && c.anonimo ? " checked" : ""}>
        Publicar como <b>anónimo</b> <small>(sale un nombre al azar en vez de tu alias)</small></label>
      <p class="com-nota">Habla de la clase, sin ataques ni datos personales.
        Puedes editarlo o borrarlo en las primeras 24 horas.</p>
      <div class="cuenta-msg" role="status"></div>
      <div class="com-form-botones">
        <button class="btn btn-primary" type="submit">${c ? "Guardar cambios" : "Publicar"}</button>
        <button class="btn" type="button" data-com="cancelar">Cancelar</button>
      </div>
    </form>`;
}

function filaRubricaHTML(r) {
  return `<div class="com-rub-fila">
      <input name="concepto" maxlength="40" placeholder="Examen, proyecto, tareas…" value="${r ? esc(r.concepto) : ""}">
      <input name="porcentaje" type="number" min="1" max="100" placeholder="%" value="${r ? r.porcentaje : ""}">
      <button type="button" class="com-acc" data-com="rub-menos" title="Quitar">✕</button>
    </div>`;
}

function actualizarFormulario(form) {
  const n = form.querySelector("textarea").value.length;
  form.querySelector(".com-contador").textContent = `${n} / ${TEXTO_MAX}`;
  const filas = form.querySelectorAll(".com-rub-fila");
  const suma = [...form.querySelectorAll("input[name=porcentaje]")].reduce((a, i) => a + (Number(i.value) || 0), 0);
  const el = form.querySelector(".com-rub-suma");
  el.textContent = filas.length ? `Suma: ${suma} %` : "";
  el.classList.toggle("mal", filas.length > 0 && suma !== 100);
  form.querySelector("[data-com=rub-mas]").hidden = filas.length >= RUBRICA_MAX;
}

function leerFormulario(form) {
  const v = Object.fromEntries(new FormData(form));
  const rubrica = [...form.querySelectorAll(".com-rub-fila")]
    .map((f) => ({ concepto: f.querySelector("[name=concepto]").value.trim(), porcentaje: Number(f.querySelector("[name=porcentaje]").value) }))
    .filter((r) => r.concepto || r.porcentaje);
  return {
    profesor: FICHA.profesor.id,
    materia: v.materia,
    calidad: Number(v.calidad),
    dificultad: Number(v.dificultad),
    recomienda: v.recomienda === "si",
    texto: v.texto,
    rubrica,
  };
}

function abrirFormulario(hueco, c) {
  document.querySelectorAll(".com-form").forEach((f) => f.remove());   // uno a la vez
  hueco.innerHTML = formComentarioHTML(c);
  const form = hueco.querySelector("form");
  actualizarFormulario(form);
  (c ? form.querySelector("textarea") : form.querySelector("select")).focus();
}

// ---------- panel corto: reportar o moderar ----------
function panelHTML(tipo, accion) {
  if (tipo === "reportar") {
    return `<form class="com-mini" data-tipo="reportar">
        <label class="campo">¿Por qué lo reportas?
          <select name="motivo" required><option value="">Elige…</option>
            ${MOTIVOS_REPORTE.map((m) => `<option>${esc(m)}</option>`).join("")}</select></label>
        <label class="campo">Detalle <small>(opcional)</small><input name="detalle" maxlength="300"></label>
        <div class="cuenta-msg" role="status"></div>
        <div class="com-form-botones">
          <button class="btn btn-danger" type="submit">Reportar</button>
          <button class="btn" type="button" data-com="cerrar-panel">Cancelar</button>
        </div>
      </form>`;
  }
  const titulos = {
    ocultar: "Ocultar este comentario", mostrar: "Volver a mostrar este comentario",
    descartar: "Descartar los reportes (el comentario se queda)",
    suspender: "Suspender al autor: no podrá comentar ni reportar", banear: "Banear al autor: no podrá entrar y se ocultan todos sus comentarios",
  };
  return `<form class="com-mini" data-tipo="mod" data-accion="${accion}">
      <div class="com-mini-tit">${titulos[accion]}</div>
      ${accion === "suspender" ? `<label class="campo">Durante<select name="dias">
          <option value="1">1 día</option><option value="7" selected>7 días</option><option value="30">30 días</option></select></label>` : ""}
      <label class="campo">Motivo ${accion === "descartar" ? "<small>(opcional)</small>" : "<small>(queda en la bitácora)</small>"}
        <input name="motivo" maxlength="300" ${accion === "descartar" ? "" : "required minlength=\"3\""}></label>
      <div class="cuenta-msg" role="status"></div>
      <div class="com-form-botones">
        <button class="btn ${accion === "banear" ? "btn-danger" : "btn-primary"}" type="submit">Confirmar</button>
        <button class="btn" type="button" data-com="cerrar-panel">Cancelar</button>
      </div>
    </form>`;
}

// ---------- eventos (delegados en la ficha, que se repinta seguido) ----------
const comById = (id) => FICHA && FICHA.comentarios.find((c) => c.id === Number(id));

profDetailEl.addEventListener("click", async (e) => {
  const b = e.target.closest("[data-com]");
  if (!b) return;
  const que = b.dataset.com;
  if (que === "entrar") { e.preventDefault(); abrirCuenta("entrar"); return; }
  if (que === "nuevo") { abrirFormulario(document.getElementById("comFormNuevo"), null); return; }
  if (que === "editar") { abrirFormulario(document.getElementById("comPanel-" + b.dataset.id), comById(b.dataset.id)); return; }
  if (que === "cancelar") { b.closest(".com-form").remove(); return; }
  if (que === "rub-mas") {
    const form = b.closest("form");
    form.querySelector(".com-rub-filas").insertAdjacentHTML("beforeend", filaRubricaHTML(null));
    actualizarFormulario(form);
    form.querySelector(".com-rub-fila:last-child input").focus();
    return;
  }
  if (que === "rub-menos") { const form = b.closest("form"); b.closest(".com-rub-fila").remove(); actualizarFormulario(form); return; }
  if (que === "reportar" || que === "mod") {
    const panel = document.getElementById("comPanel-" + b.dataset.id);
    panel.innerHTML = panelHTML(que, b.dataset.accion);
    panel.querySelector("select, input").focus();
    return;
  }
  if (que === "cerrar-panel") { b.closest(".com-panel").innerHTML = ""; return; }
  if (que === "borrar") {
    if (!confirm("¿Borrar tu comentario? No se puede deshacer.")) return;
    try { await apiCuenta("comentarios/borrar.php", { id: Number(b.dataset.id) }); refrescarComentarios(); }
    catch (err) { alert(err.message); }
  }
});

profDetailEl.addEventListener("input", (e) => {
  const form = e.target.closest(".com-form");
  if (form) actualizarFormulario(form);
});

profDetailEl.addEventListener("submit", async (e) => {
  const form = e.target.closest(".com-form, .com-mini");
  if (!form) return;
  e.preventDefault();
  const msg = form.querySelector(".cuenta-msg");
  const boton = form.querySelector("button[type=submit]");
  boton.disabled = true;
  try {
    if (form.classList.contains("com-form")) {
      const datos = leerFormulario(form);
      datos.anonimo = !!form.querySelector("[name=anonimo]")?.checked;
      if (form.dataset.id) datos.id = Number(form.dataset.id);
      await apiCuenta("comentarios/guardar.php", datos);
      refrescarComentarios();
      return;
    }
    const id = Number(form.closest(".com").id.replace("com-", ""));
    const v = Object.fromEntries(new FormData(form));
    if (form.dataset.tipo === "reportar") {
      await apiCuenta("comentarios/reportar.php", { id, motivo: v.motivo, detalle: v.detalle });
      mostrarMsg(msg, "Gracias: un moderador lo va a revisar.");
      setTimeout(refrescarComentarios, 1200);
    } else {
      const r = await apiCuenta("moderacion/accion.php",
        { accion: form.dataset.accion, comentario: id, motivo: v.motivo || "", dias: v.dias ? Number(v.dias) : undefined });
      mostrarMsg(msg, r.mensaje);
      setTimeout(refrescarComentarios, 1200);
    }
  } catch (err) {
    mostrarMsg(msg, err.message, true);
    boton.disabled = false;
  }
});

// ============================================================
//  "Reportes pendientes" en la ventana de la cuenta (moderadores)
// ============================================================
VISTAS.reportes = () => ["Reportes pendientes", `<div id="modReportes"><div class="drop-empty">Cargando…</div></div>`];

async function cargarReportes() {
  const caja = document.getElementById("modReportes");
  if (!caja) return;
  try {
    const lista = await apiCuenta("moderacion/reportes.php");
    if (!lista.length) {
      caja.innerHTML = `<div class="drop-empty">No hay reportes pendientes. 🎉</div>
        <div class="cuenta-links"><a href="#" data-vista="miCuenta">Volver a tu cuenta</a></div>`;
      return;
    }
    caja.innerHTML = `<p class="cuenta-nota">${lista.length} ${lista.length === 1 ? "comentario reportado" : "comentarios reportados"}.
        Abre la ficha del maestro para ocultar, descartar o sancionar.</p>` +
      lista.map(({ comentario: c, reportes }) => `
        <div class="mod-item">
          <div class="mod-cab"><b>${esc(c.profesor)}</b> · ${esc(c.materia)}</div>
          <div class="mod-autor">${c.autor ? esc(c.autor) : "<i>Usuario eliminado</i>"} · ${esc(c.creado)}
            ${c.estado === "oculto" ? `<span class="com-oculto">Oculto</span>` : ""}
            ${c.autor_baneado ? `<span class="com-oculto">Autor baneado</span>` : c.autor_suspendido ? `<span class="com-oculto">Suspendido hasta ${esc(c.autor_suspendido)}</span>` : ""}</div>
          <p class="com-texto">${esc(c.texto)}</p>
          <ul class="mod-motivos">${reportes.map((r) => `<li>${esc(r.motivo)} <small>— ${r.reportante ? esc(r.reportante) : "usuario eliminado"}, ${esc(r.creado)}</small></li>`).join("")}</ul>
          <button class="btn" data-ir-prof="${esc(c.profesor)}" data-com-id="${c.id}">Ver en la ficha</button>
        </div>`).join("");
  } catch (e) {
    caja.innerHTML = `<div class="drop-empty">${esc(e.message)}</div>`;
  }
}

// Lo llama abrirCuenta() (cuenta.js) cada vez que pinta una vista.
function alAbrirVistaCuenta(vista) {
  cuentaEl.querySelector(".modal-box").classList.toggle("modal-sm", vista !== "reportes");
  if (vista === "reportes") cargarReportes();
}

cuentaBodyEl.addEventListener("click", (e) => {
  const b = e.target.closest("[data-ir-prof]");
  if (!b) return;
  cerrarModal(cuentaEl);
  showProfDetail(b.dataset.irProf);
  // Cuando lleguen los comentarios, llevar la vista al reportado.
  const id = b.dataset.comId;
  const buscar = (n) => {
    const el = document.getElementById("com-" + id);
    if (el) { el.scrollIntoView({ behavior: "smooth", block: "center" }); el.classList.add("resaltado"); }
    else if (n > 0) setTimeout(() => buscar(n - 1), 250);
  };
  buscar(20);
});

// Si la ficha ya estaba abierta cuando cargó este módulo (o al entrar a la
// cuenta sin recargar), que se pinten los comentarios.
refrescarComentarios();
