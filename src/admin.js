// ============================================================
//  PESTAÑA ADMIN — moderadores y administrador
// ============================================================
// Solo se descarga si tu cuenta es de moderador o admin (cuenta.js,
// mostrarPestanaAdmin). Esconder la pestaña no protege nada: cada endpoint
// de api/admin/ revisa EN EL SERVIDOR quién eres, qué carreras moderas y,
// para lo delicado, que hayas escrito otra vez tu contraseña.
//
// Secciones:
//   Tablero      números del sitio y (admin) estado del sistema, probar el
//                correo y bajar el respaldo
//   Reportes     comentarios reportados, para ocultar, descartar o sancionar
//   Comentarios  todos, con filtros (carrera, estado, reportados, búsqueda)
//   Bitácora     lo que han hecho moderadores y admin
//   Usuarios     (solo admin) correos, nombrar moderadores, cambiar alias
// ============================================================

(function () {
  const pane = document.getElementById("pane-admin");
  if (!pane) return;

  const esAdmin = () => !!USUARIO && USUARIO.rol === "admin";
  const SECCIONES = [
    ["tablero", "📊 Tablero"], ["reportes", "🚩 Reportes"], ["comentarios", "💬 Comentarios"],
    ["bitacora", "📜 Bitácora"], ["usuarios", "👥 Usuarios", true],
  ];
  const NOMBRE_ACCION = {
    ocultar: "Ocultó", mostrar: "Mostró", suspender: "Suspendió", banear: "Baneó", desbanear: "Desbaneó",
    nombrar_moderador: "Nombró moderador", quitar_moderador: "Quitó moderador",
    carreras_moderador: "Cambió carreras de moderador", cambiar_alias: "Cambió alias",
    ver_correo: "Vio correos", respaldo: "Bajó respaldo", probar_correo: "Probó el correo",
  };

  let seccion = "tablero";
  let carreras = [];                     // las que moderas (las manda el tablero)
  const filtros = {
    comentarios: { carrera: "", estado: "", reportados: false, q: "", pagina: 1 },
    bitacora: { accion: "", pagina: 1 },
    usuarios: { q: "", rol: "", pagina: 1 },
  };

  // ---------- API: si pide la contraseña, se pide y se reintenta ----------
  async function api(ruta, datos, comoArchivo) {
    for (let intento = 0; intento < 2; intento++) {
      const r = await fetch("api/" + ruta, datos === undefined
        ? { cache: "no-store" }
        : { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(datos) });
      if (r.ok && comoArchivo) return r;
      let j = {};
      try { j = await r.json(); } catch (e) { /* vacía */ }
      if (r.ok) return j;
      if (r.status === 403 && j.confirmar && intento === 0) { await pedirContrasena(); continue; }
      throw new Error(j.error || "Algo falló (" + r.status + ").");
    }
  }

  // Ventana "Escribe otra vez tu contraseña". Resuelve cuando la confirmas.
  function pedirContrasena() {
    return new Promise((resolve, reject) => {
      const caja = document.createElement("div");
      caja.className = "modal";
      caja.innerHTML = `
        <div class="modal-box modal-sm" role="dialog" aria-modal="true" aria-labelledby="admConfTit">
          <header class="modal-head"><h2 id="admConfTit">Confirma que eres tú</h2>
            <button class="iconbtn" type="button" data-cerrar aria-label="Cerrar">✕</button></header>
          <div class="modal-body">
            <form class="cuenta-form">
              <p class="cuenta-nota">Esto es delicado (correos, roles, respaldo). Escribe otra vez tu
                contraseña; vale 10 minutos.</p>
              <label class="campo">Contraseña
                <input type="password" name="contrasena" autocomplete="current-password" required></label>
              <div class="cuenta-msg" role="status"></div>
              <button class="btn btn-primary" type="submit">Confirmar</button>
            </form>
          </div>
        </div>`;
      document.body.appendChild(caja);
      const input = caja.querySelector("input");
      input.focus();
      const cerrar = (ok) => { caja.remove(); ok ? resolve() : reject(new Error("Se canceló: no confirmaste tu contraseña.")); };
      caja.addEventListener("click", (e) => { if (e.target === caja || e.target.closest("[data-cerrar]")) cerrar(false); });
      caja.querySelector("form").addEventListener("submit", async (e) => {
        e.preventDefault();
        const msg = caja.querySelector(".cuenta-msg");
        const boton = caja.querySelector("button[type=submit]");
        boton.disabled = true;
        try {
          await api("admin/confirmar.php", { contrasena: input.value });
          cerrar(true);
        } catch (err) {
          mostrarMsg(msg, err.message, true);
          boton.disabled = false;
          input.select();
        }
      });
    });
  }

  // ---------- armado de la pestaña ----------
  function renderAdmin() {
    if (!USUARIO || USUARIO.rol === "alumno") { pane.innerHTML = ""; return; }
    if (!pane.querySelector(".adm-nav")) {
      pane.innerHTML = `
        <div class="pane-head">
          <h2 class="pane-title">${esAdmin() ? "Administración" : "Moderación"}</h2>
          <p class="pane-sub" id="admSub">Cada acción queda en la bitácora.</p>
          <div class="adm-nav" role="tablist">
            ${SECCIONES.filter(([, , soloAdmin]) => !soloAdmin || esAdmin()).map(([k, t]) =>
              `<button class="chip" data-adm-sec="${k}" aria-pressed="false">${t}</button>`).join("")}
          </div>
        </div>
        <div id="admBody"></div>`;
    }
    pane.querySelectorAll("[data-adm-sec]").forEach((b) => b.setAttribute("aria-pressed", b.dataset.admSec === seccion));
    pintarSeccion();
  }
  window.renderAdmin = renderAdmin;

  const cuerpo = () => document.getElementById("admBody");
  const cargando = () => { cuerpo().innerHTML = `<div class="drop-empty">Cargando…</div>`; };
  const fallo = (e) => { cuerpo().innerHTML = `<div class="drop-empty">${esc(e.message)}</div>`; };

  async function pintarSeccion() {
    cargando();
    try {
      if (seccion === "tablero") await pintarTablero();
      else if (seccion === "reportes") await pintarReportes();
      else if (seccion === "comentarios") await pintarComentarios();
      else if (seccion === "bitacora") await pintarBitacora();
      else if (seccion === "usuarios") await pintarUsuarios();
    } catch (e) { fallo(e); }
  }

  const num = (n) => Number(n || 0).toLocaleString("es-MX");
  const stat = (n, t, extra) => `<div class="adm-stat${extra ? " " + extra : ""}"><b>${num(n)}</b><span>${t}</span></div>`;

  // Qué carreras moderas (las dice el tablero) y el subtítulo que lo explica.
  function anotarCarreras(t) {
    carreras = t.carreras;
    const sub = document.getElementById("admSub");
    if (sub) sub.textContent = esAdmin()
      ? "Moderas todas las carreras. Solo tú y los moderadores ven esta pestaña; cada acción queda en la bitácora."
      : `Moderas ${t.carreras.join(", ") || "ninguna carrera (pídeselo al admin)"}. Cada acción queda en la bitácora.`;
  }

  // ---------- Tablero ----------
  async function pintarTablero() {
    const t = await api("admin/tablero.php");
    anotarCarreras(t);
    const u = t.usuarios, c = t.comentarios, r = t.reportes, d = t.datos;
    let html = `
      <h3 class="adm-tit">Cuentas</h3>
      <div class="adm-stats">
        ${stat(u.activas, "cuentas activas")}${stat(u.nuevas_7d, "nuevas esta semana")}
        ${stat(u.isc, "de ISC")}${stat(u.ia, "de IA")}${stat(u.lcd, "de LCD")}
        ${stat(u.con_avance, "guardaron su avance")}${stat(u.con_horario, "guardaron su horario")}
        ${stat(u.recordatorios, "recordatorios")}${stat(u.moderadores, "moderadores")}
        ${stat(u.suspendidas, "suspendidas", u.suspendidas ? "alerta" : "")}${stat(u.baneadas, "baneadas", u.baneadas ? "alerta" : "")}
        ${stat(u.sin_activar, "sin activar")}
      </div>
      <h3 class="adm-tit">Comentarios ${esAdmin() ? "" : "de tus carreras"}</h3>
      <div class="adm-stats">
        ${stat(r.comentarios_reportados, "con reportes pendientes", r.pendientes ? "alerta" : "")}
        ${stat(c.visibles, "visibles")}${stat(c.ocultos, "ocultos")}${stat(c.nuevos_7d, "nuevos esta semana")}
        ${stat(c.anonimos, "anónimos")}${stat(r.resueltos_30d, "reportes resueltos (30 días)")}
      </div>
      <h3 class="adm-tit">Datos del periodo ${esc(d.periodo)}</h3>
      <div class="adm-stats">
        ${stat(d.ofertas, "ofertas")}${stat(d.profes_con_clase, "profes con clase")}${stat(d.profesores, "profes en total")}
        ${stat(d.materias, "materias")}${stat(d.profes_sin_metricas, "profes sin métricas")}
      </div>`;
    if (t.estado) {
      const e = t.estado;
      const fila = (ok, titulo, detalle) =>
        `<li class="adm-salud" data-ok="${ok}"><span>${ok ? "✅" : "⚠️"}</span><b>${titulo}</b><small>${detalle}</small></li>`;
      html += `
        <h3 class="adm-tit">Estado del sistema</h3>
        <ul class="adm-salud-lista">
          ${fila(e.base.ok, "Base de datos", `PostgreSQL ${esc(e.base.version)} · ${esc(e.base.tamano)} · hora del servidor ${esc(e.base.hora)}`)}
          ${fila(e.sitio.ok, "Sitio público", e.sitio.ok
            ? `${esc(e.sitio.url)} contesta (${e.sitio.ms} ms)`
            : `${esc(e.sitio.url)} no contesta${e.sitio.codigo ? " (" + e.sitio.codigo + ")" : ""}: ¿está prendido ngrok?`)}
          ${fila(e.correo.configurado, "Correo", e.correo.configurado ? "Gmail configurado en el .env" : "Falta SMTP en el .env: los correos salen en docker compose logs web")}
          ${fila(!!e.respaldo, "Último respaldo desde la app", e.respaldo ? esc(e.respaldo) : "nunca")}
          ${fila(true, "PHP", esc(e.php))}
        </ul>
        <div class="adm-botones">
          <button class="btn" data-adm="probar-correo">✉️ Mandarme un correo de prueba</button>
          <button class="btn" data-adm="respaldo">💾 Descargar respaldo de datos</button>
        </div>
        <div class="cuenta-msg" role="status" id="admMsgSis"></div>
        <p class="cuenta-nota">El respaldo trae correos y contraseñas cifradas: guárdalo fuera del repositorio
          (ver <code>docs/respaldo.md</code>).</p>`;
    }
    cuerpo().innerHTML = html;
  }

  // ---------- formulario de acción sobre un comentario ----------
  // ocultar / mostrar / descartar reportes / suspender / banear, con motivo.
  function formAccion(c, reportes) {
    const opciones = [];
    opciones.push(c.estado === "visible" ? ["ocultar", "Ocultar el comentario"] : ["mostrar", "Volver a mostrarlo"]);
    if (reportes) opciones.push(["descartar", "Descartar los reportes (se queda)"]);
    const autorModerable = c.autor_id && c.autor_rol !== "admin" && c.autor_id !== undefined
      && (c.autor_rol !== "moderador" || esAdmin());
    if (autorModerable && !c.autor_baneado) {
      opciones.push(["suspender-1", "Suspender al autor 1 día"], ["suspender-7", "Suspender al autor 7 días"],
                    ["suspender-30", "Suspender al autor 30 días"], ["banear", "Banear al autor"]);
    }
    return `
      <form class="adm-accion" data-com-id="${c.id}">
        <select name="accion" aria-label="Acción">${opciones.map(([v, t]) => `<option value="${v}">${t}</option>`).join("")}</select>
        <input name="motivo" maxlength="500" placeholder="Motivo (queda en la bitácora)" aria-label="Motivo">
        <button class="btn" type="submit">Aplicar</button>
        <button class="btn" type="button" data-ir-prof="${esc(c.profesor)}" data-com-id="${c.id}">Ver en la ficha</button>
        <div class="cuenta-msg" role="status"></div>
      </form>`;
  }

  function autorDe(c) {
    if (!c.autor) return "<i>Cuenta borrada</i>";
    return c.anonimo
      ? `${esc(c.anonimo)} <span class="com-anon">anónimo</span> <small>(es ${esc(c.autor)})</small>`
      : esc(c.autor);
  }

  // ---------- Reportes ----------
  async function pintarReportes() {
    const lista = await api("moderacion/reportes.php");
    if (!lista.length) { cuerpo().innerHTML = `<div class="drop-empty big">No hay reportes pendientes. 🎉</div>`; return; }
    cuerpo().innerHTML = `<p class="cuenta-nota">${lista.length} ${lista.length === 1 ? "comentario reportado" : "comentarios reportados"}.</p>` +
      lista.map(({ comentario: c, reportes }) => `
        <div class="mod-item">
          <div class="mod-cab"><span class="adm-car">${esc(c.carrera)}</span> <b>${esc(c.profesor)}</b> · ${esc(c.materia)}</div>
          <div class="mod-autor">${autorDe(c)} · ${esc(c.creado)}
            ${c.estado === "oculto" ? `<span class="com-oculto">Oculto</span>` : ""}
            ${c.autor_baneado ? `<span class="com-oculto">Autor baneado</span>` : c.autor_suspendido ? `<span class="com-oculto">Suspendido hasta ${esc(c.autor_suspendido)}</span>` : ""}</div>
          <p class="com-texto">${esc(c.texto)}</p>
          <ul class="mod-motivos">${reportes.map((r) => `<li>${esc(r.motivo)} <small>— ${r.reportante ? esc(r.reportante) : "cuenta borrada"}, ${esc(r.creado)}</small></li>`).join("")}</ul>
          ${formAccion(c, reportes.length)}
        </div>`).join("");
  }

  // ---------- Comentarios ----------
  async function pintarComentarios() {
    const f = filtros.comentarios;
    if (!carreras.length) anotarCarreras(await api("admin/tablero.php"));
    const qs = new URLSearchParams({ carrera: f.carrera, estado: f.estado, q: f.q, pagina: f.pagina });
    if (f.reportados) qs.set("reportados", "1");
    const r = await api("admin/comentarios.php?" + qs);
    const barra = `
      <form class="adm-filtros" data-filtros="comentarios">
        <input class="search" name="q" value="${esc(f.q)}" placeholder="Buscar en el texto, profesor o alias…" aria-label="Buscar">
        <select name="carrera" aria-label="Carrera"><option value="">Todas tus carreras</option>
          ${carreras.map((k) => `<option ${f.carrera === k ? "selected" : ""}>${k}</option>`).join("")}</select>
        <select name="estado" aria-label="Estado">
          <option value="">Visibles y ocultos</option>
          <option value="visible" ${f.estado === "visible" ? "selected" : ""}>Solo visibles</option>
          <option value="oculto" ${f.estado === "oculto" ? "selected" : ""}>Solo ocultos</option></select>
        <label class="adm-check"><input type="checkbox" name="reportados" ${f.reportados ? "checked" : ""}> Con reportes</label>
        <button class="btn" type="submit">Filtrar</button>
      </form>`;
    const items = r.comentarios.map((c) => `
      <div class="mod-item">
        <div class="mod-cab"><span class="adm-car">${esc(c.carrera)}</span> <b>${esc(c.profesor)}</b> · ${esc(c.materia)}</div>
        <div class="mod-autor">${autorDe(c)} · ${esc(c.creado)} · calidad ${c.calidad} · dificultad ${c.dificultad} ·
          ${c.recomienda ? "lo recomienda" : "no lo recomienda"}
          ${c.estado === "oculto" ? `<span class="com-oculto">Oculto</span>` : ""}
          ${c.reportes ? `<span class="com-reportes">${c.reportes} ${c.reportes === 1 ? "reporte" : "reportes"}</span>` : ""}</div>
        <p class="com-texto">${esc(c.texto)}</p>
        ${formAccion(c, c.reportes)}
      </div>`).join("");
    cuerpo().innerHTML = barra + `<p class="cuenta-nota">${num(r.total)} ${r.total === 1 ? "comentario" : "comentarios"}.</p>`
      + (items || `<div class="drop-empty">Nada con esos filtros.</div>`) + paginas("comentarios", r.total, r.por_pagina);
  }

  function paginas(cual, total, porPagina) {
    const n = Math.ceil(total / porPagina);
    if (n <= 1) return "";
    const p = filtros[cual].pagina;
    return `<div class="adm-paginas">
      <button class="btn" data-pagina="${cual}:${p - 1}" ${p <= 1 ? "disabled" : ""}>← Anterior</button>
      <span>Página ${p} de ${n}</span>
      <button class="btn" data-pagina="${cual}:${p + 1}" ${p >= n ? "disabled" : ""}>Siguiente →</button></div>`;
  }

  // ---------- Bitácora ----------
  async function pintarBitacora() {
    const f = filtros.bitacora;
    const r = await api("admin/bitacora.php?" + new URLSearchParams({ accion: f.accion, pagina: f.pagina }));
    const barra = `
      <form class="adm-filtros" data-filtros="bitacora">
        <select name="accion" aria-label="Acción"><option value="">Todas las acciones</option>
          ${r.acciones.map((a) => `<option value="${a}" ${f.accion === a ? "selected" : ""}>${NOMBRE_ACCION[a] || a}</option>`).join("")}</select>
        <button class="btn" type="submit">Filtrar</button>
      </form>`;
    const filas = r.filas.map((b) => `
      <tr><td class="num">${esc(b.cuando)}</td><td>${b.actor ? esc(b.actor) : "<i>cuenta borrada</i>"}</td>
        <td>${esc(NOMBRE_ACCION[b.accion] || b.accion)}</td>
        <td>${b.usuario ? esc(b.usuario) : ""}${b.profesor ? `<small> · comentario sobre ${esc(b.profesor)}</small>` : ""}
          ${b.comentario_texto ? `<div class="adm-extracto">“${esc(b.comentario_texto)}”</div>` : ""}</td>
        <td>${esc(b.motivo || "")}</td></tr>`).join("");
    cuerpo().innerHTML = barra + `<p class="cuenta-nota">${num(r.total)} ${r.total === 1 ? "acción" : "acciones"}.</p>`
      + (filas ? `<div class="table-wrap"><table class="adm-tabla"><thead><tr><th>Cuándo</th><th>Quién</th><th>Qué</th>
          <th>A quién</th><th>Motivo</th></tr></thead><tbody>${filas}</tbody></table></div>` : `<div class="drop-empty">Nada todavía.</div>`)
      + paginas("bitacora", r.total, r.por_pagina);
  }

  // ---------- Usuarios (solo admin) ----------
  async function pintarUsuarios() {
    const f = filtros.usuarios;
    let r;
    try {
      r = await api("admin/usuarios.php?" + new URLSearchParams({ q: f.q, rol: f.rol, pagina: f.pagina }));
    } catch (e) {
      cuerpo().innerHTML = `<div class="drop-empty">${esc(e.message)}</div>
        <p><button class="btn" data-adm="reintentar">Intentar de nuevo</button></p>`;
      return;
    }
    const barra = `
      <form class="adm-filtros" data-filtros="usuarios">
        <input class="search" name="q" value="${esc(f.q)}" placeholder="Buscar por correo o alias…" aria-label="Buscar">
        <select name="rol" aria-label="Rol"><option value="">Todos los roles</option>
          ${["alumno", "moderador", "admin"].map((k) => `<option ${f.rol === k ? "selected" : ""}>${k}</option>`).join("")}</select>
        <button class="btn" type="submit">Buscar</button>
      </form>
      <p class="cuenta-nota">🔒 Solo tú ves los correos. Ver esta lista queda en la bitácora.</p>`;
    const estado = (u) => u.baneado ? `<span class="com-oculto">Baneada</span>`
      : u.suspendido_hasta ? `<span class="com-oculto">Suspendida hasta ${esc(u.suspendido_hasta)}</span>`
      : !u.verificado ? `<span class="com-reportes">Sin activar</span>` : "Activa";
    const filas = r.usuarios.map((u) => `
      <tr data-usuario="${u.id}" data-alias="${esc(u.alias)}" data-rol="${u.rol}" data-modera="${u.modera.join(",")}" data-carrera="${u.carrera}">
        <td><b>${esc(u.alias)}</b><div class="adm-extracto">${esc(u.correo)}</div></td>
        <td>${esc(u.carrera)}</td>
        <td>${u.rol === "admin" ? "Admin" : u.rol === "moderador" ? `Moderador <small>(${esc(u.modera.join(", ") || "nada")})</small>` : "Alumno"}</td>
        <td>${estado(u)}</td>
        <td class="num">${u.comentarios}${u.ocultos ? ` <small>(${u.ocultos} ocultos)</small>` : ""}</td>
        <td class="num">${esc(u.creado)}</td>
        <td>${u.rol === "admin" ? "" : `<button class="btn" data-adm="rol">Rol</button> <button class="btn" data-adm="alias">Alias</button>`}</td>
      </tr>`).join("");
    cuerpo().innerHTML = barra + `<p class="cuenta-nota">${num(r.total)} ${r.total === 1 ? "cuenta" : "cuentas"}.</p>`
      + (filas ? `<div class="table-wrap"><table class="adm-tabla"><thead><tr><th>Alias y correo</th><th>Carrera</th><th>Rol</th>
          <th>Estado</th><th>Comentarios</th><th>Desde</th><th></th></tr></thead><tbody>${filas}</tbody></table></div>`
        : `<div class="drop-empty">Nadie con esa búsqueda.</div>`)
      + paginas("usuarios", r.total, r.por_pagina);
  }

  // Formulario debajo de la fila de un usuario: rol y carreras, o alias.
  function abrirFormUsuario(tr, tipo) {
    pane.querySelectorAll(".adm-fila-form").forEach((x) => x.remove());
    const d = tr.dataset;
    const modera = d.modera ? d.modera.split(",") : [d.carrera];
    const html = tipo === "rol" ? `
        <label class="adm-check"><input type="radio" name="rol" value="moderador" ${d.rol === "moderador" ? "checked" : ""}> Moderador de:</label>
        ${["ISC", "IA", "LCD"].map((k) => `<label class="adm-check"><input type="checkbox" name="carreras" value="${k}" ${modera.includes(k) ? "checked" : ""}> ${k}</label>`).join("")}
        <label class="adm-check"><input type="radio" name="rol" value="alumno" ${d.rol === "alumno" ? "checked" : ""}> Alumno (sin moderar)</label>`
      : `<input name="alias" maxlength="30" value="${esc(d.alias)}" aria-label="Alias nuevo">
         <small class="cuenta-nota">No le cuenta para sus 3 cambios al año.</small>`;
    const fila = document.createElement("tr");
    fila.className = "adm-fila-form";
    fila.innerHTML = `<td colspan="7"><form class="adm-usuario" data-tipo="${tipo}" data-usuario="${d.usuario}">
        <b>${tipo === "rol" ? "Rol de" : "Cambiar el alias de"} «${esc(d.alias)}»</b> ${html}
        <input name="motivo" maxlength="500" placeholder="Motivo (queda en la bitácora)" aria-label="Motivo" required>
        <button class="btn btn-primary" type="submit">Guardar</button> <button class="btn" type="button" data-adm="cancelar">Cancelar</button>
        <div class="cuenta-msg" role="status"></div></form></td>`;
    tr.after(fila);
    fila.querySelector("input[name=motivo]").focus();
  }

  // ---------- descargar el respaldo ----------
  async function bajarRespaldo(msg) {
    mostrarMsg(msg, "Armando el respaldo…");
    const r = await api("admin/respaldo.php", {}, true);
    const nombre = (r.headers.get("Content-Disposition") || "").match(/filename="([^"]+)"/)?.[1] || "gestorix-datos.sql";
    const url = URL.createObjectURL(await r.blob());
    const a = document.createElement("a");
    a.href = url; a.download = nombre;
    document.body.appendChild(a); a.click(); a.remove();
    setTimeout(() => URL.revokeObjectURL(url), 5000);
    mostrarMsg(msg, `Listo: ${nombre}. Guárdalo fuera del repositorio.`);
  }

  // ---------- eventos ----------
  pane.addEventListener("click", async (e) => {
    const sec = e.target.closest("[data-adm-sec]");
    if (sec) { seccion = sec.dataset.admSec; renderAdmin(); return; }

    const pag = e.target.closest("[data-pagina]");
    if (pag) { const [cual, p] = pag.dataset.pagina.split(":"); filtros[cual].pagina = Number(p); pintarSeccion(); return; }

    const prof = e.target.closest("[data-ir-prof]");
    if (prof) { irAComentario(prof.dataset.irProf, prof.dataset.comId); return; }

    const b = e.target.closest("[data-adm]");
    if (!b) return;
    const accion = b.dataset.adm;
    if (accion === "reintentar") { pintarSeccion(); return; }
    if (accion === "cancelar") { b.closest(".adm-fila-form").remove(); return; }
    if (accion === "rol" || accion === "alias") { abrirFormUsuario(b.closest("tr"), accion); return; }
    const msg = document.getElementById("admMsgSis");
    b.disabled = true;
    try {
      if (accion === "probar-correo") {
        const r = await api("admin/probar-correo.php", {});
        mostrarMsg(msg, r.enviado ? `Enviado a ${r.para}. Revisa también la carpeta de spam.`
          : "No salió: " + (r.configurado ? "Gmail rechazó el envío (revisa docker compose logs web)." : "falta configurar SMTP en el .env."), !r.enviado);
      }
      if (accion === "respaldo") await bajarRespaldo(msg);
    } catch (err) {
      mostrarMsg(msg, err.message, true);
    } finally {
      b.disabled = false;
    }
  });

  pane.addEventListener("submit", async (e) => {
    const form = e.target;
    e.preventDefault();
    if (form.dataset.filtros) {                       // barra de filtros
      const cual = form.dataset.filtros;
      const v = Object.fromEntries(new FormData(form));
      Object.assign(filtros[cual], v, { pagina: 1 });
      if (cual === "comentarios") filtros.comentarios.reportados = !!v.reportados;
      pintarSeccion();
      return;
    }
    const msg = form.querySelector(".cuenta-msg");
    const boton = form.querySelector("button[type=submit]");
    boton.disabled = true;
    try {
      if (form.classList.contains("adm-accion")) {     // acción sobre un comentario
        const v = Object.fromEntries(new FormData(form));
        const [accion, dias] = v.accion.split("-");
        if (accion === "banear" && !confirm("¿Banear a esta cuenta? Se ocultan todos sus comentarios.")) { boton.disabled = false; return; }
        const r = await api("moderacion/accion.php",
          { accion, comentario: Number(form.dataset.comId), motivo: v.motivo, dias: dias ? Number(dias) : undefined });
        mostrarMsg(msg, r.mensaje);
        setTimeout(pintarSeccion, 1200);
      } else if (form.classList.contains("adm-usuario")) {   // rol o alias
        const fd = new FormData(form);
        const datos = { accion: form.dataset.tipo, usuario: Number(form.dataset.usuario), motivo: fd.get("motivo") };
        if (form.dataset.tipo === "rol") {
          datos.rol = fd.get("rol") || "alumno";
          datos.carreras = fd.getAll("carreras");
        } else {
          datos.alias = fd.get("alias");
        }
        const r = await api("admin/usuario.php", datos);
        mostrarMsg(msg, r.mensaje);
        setTimeout(pintarSeccion, 1200);
      }
    } catch (err) {
      mostrarMsg(msg, err.message, true);
      boton.disabled = false;
    }
  });

  // Abre la ficha del maestro y lleva la vista al comentario.
  function irAComentario(profesor, id) {
    showProfDetail(profesor);
    const buscar = (n) => {
      const el = document.getElementById("com-" + id);
      if (el) { el.scrollIntoView({ behavior: "smooth", block: "center" }); el.classList.add("resaltado"); }
      else if (n > 0) setTimeout(() => buscar(n - 1), 250);
    };
    buscar(20);
  }

  // Botón "Abrir la pestaña Admin" de la ventana de tu cuenta.
  cuentaBodyEl.addEventListener("click", (e) => {
    const b = e.target.closest("[data-ir-admin]");
    if (!b) return;
    e.preventDefault();
    cerrarModal(cuentaEl);
    seccion = b.dataset.irAdmin || "tablero";
    irAPestana("admin");
  });

  // Enlace del correo de reporte: ?admin=reportes
  const url = new URL(location.href);
  const pedida = url.searchParams.get("admin");
  if (pedida !== null) {
    url.searchParams.delete("admin");
    history.replaceState(null, "", url.pathname + url.search + url.hash);
    if (SECCIONES.some(([k, , soloAdmin]) => k === pedida && (!soloAdmin || esAdmin()))) seccion = pedida;
    irAPestana("admin");
    document.getElementById("tabAdmin")?.scrollIntoView({ block: "nearest", inline: "nearest" });   // en celular queda a la derecha
  }
})();
