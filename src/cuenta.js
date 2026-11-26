// ============================================================
//  CUENTA — entrar, crear cuenta y guardar en la base
// ============================================================
// Sin cuenta, todo vive en este navegador (localStorage), como en iscweb.
// Con cuenta, el avance y el horario se guardan además en la base
// (api/mis-datos.php) y te siguen a cualquier navegador.
//
// Decisiones del usuario (CLAUDE.md §5):
//   · al entrar, si la cuenta está vacía se sube lo de este navegador; si
//     ya tiene datos, manda la cuenta;
//   · la carrera queda fija: con sesión, la app usa la de tu cuenta.
//
// Al salir se borra de este navegador lo que era de la cuenta, para que en
// una compu compartida el siguiente no vea tu avance (sigue en tu cuenta).

let USUARIO = null;
const cuentaEl = document.getElementById("cuenta");
const cuentaTitEl = document.getElementById("cuentaTit");
const cuentaBodyEl = document.getElementById("cuentaBody");
const cuentaBtnEl = document.getElementById("cuentaBtn");

// ---------- llamadas a la API ----------
async function apiCuenta(ruta, datos) {
  const r = await fetch("api/" + ruta, datos === undefined
    ? { cache: "no-store" }
    : { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(datos) });
  let j = {};
  try { j = await r.json(); } catch (e) { /* respuesta vacía */ }
  if (!r.ok) throw new Error(j.error || "Algo falló (" + r.status + "). Intenta de nuevo.");
  return j;
}

// ============================================================
//  Estado del navegador  ⇄  tablas avance y horario
// ============================================================
// En el navegador el avance va por POSICIÓN en el plan ("s0-0" = 1.er
// semestre, 1.ª materia) y en la base por CLAVE oficial ("C103"). data.js
// trae el puente (ID_DE_CLAVE / CLAVE_DE_ID); los lugares de optativa
// guardan la clave de la optativa elegida.

const vacio = (v) => v === "" || v == null;

function estadoAFilas() {
  const filas = [];
  Object.entries(state.subjects).forEach(([id, r]) => {
    const clave = CLAVE_DE_ID[id] || (OPT_SLOTS[id] && r.clave);
    if (!clave) return;
    const calif = vacio(r.calif) ? null : Number(r.calif);
    const ets = vacio(r.calif_ets) ? null : Number(r.calif_ets);
    const veces = Number(r.veces || 1);
    // Aprobada / reprobada sin número (para quien no quiere dar calificaciones).
    const resultado = calif === null && r.res ? r.res : null;
    const resultado_ets = ets === null && r.res_ets ? r.res_ets : null;
    // Proyecto (TT I, TT II, Estancia) que marcó que está llevando.
    const proyecto_en_curso = !!r.proy && esProyecto(id);
    // Una obligatoria sin nada capturado es igual a no tener fila.
    if (!OPT_SLOTS[id] && veces === 1 && calif === null && ets === null && !resultado && !resultado_ets
        && !proyecto_en_curso) return;
    // Para el aviso de desfase, nunca antes del ingreso (lo exige la API).
    const periodo_reprobada = perDesdeIngreso(r.per_rep || "", state.ingreso) || null;
    filas.push({ materia: clave, veces, calif, calif_ets: ets, resultado, resultado_ets, periodo_reprobada, proyecto_en_curso });
  });
  return filas;
}

// Lo que se sube a mis-datos.php.
function datosParaSubir() {
  return { avance: estadoAFilas(), horario: horarioAIds(), ingreso: state.ingreso || null };
}

// Ids de oferta del horario. Si un renglón viejo no trae id, se busca su
// oferta por grupo + profesor + materia.
function horarioAIds() {
  const sched = schedActual();
  return state.horario.map((h) => {
    if (Number.isInteger(h.oferta)) return h.oferta;
    const o = sched.find((e) => e.grupo === h.grupo && norm(e.profesor) === norm(h.maestro) &&
                                (!h.matReal || norm(e.materia) === norm(h.matReal)));
    return o ? o.id : null;
  }).filter(Number.isInteger);
}

function aplicarDatos(d) {
  const libres = {};                       // semestre → lugares de optativa sin usar, en orden
  Object.entries(OPT_SLOTS).forEach(([id, sl]) => { (libres[sl.sem] = libres[sl.sem] || []).push(id); });
  const slotPara = (clave) => {
    const ya = Object.keys(state.subjects).find((k) => OPT_SLOTS[k] && state.subjects[k].clave === clave);
    if (ya) return ya;
    const opt = PLAN_ACTIVO.optativas.find((o) => o.clave === clave);
    const slot = opt && (libres[opt.sem] || []).shift();
    if (slot) state.subjects[slot] = { clave, name: nombreDeSlot(slot, opt.saes) };
    return slot || null;
  };

  state.subjects = {};
  d.avance.forEach((f) => {
    const rec = {
      veces: f.veces,
      calif: vacio(f.calif) ? "" : String(f.calif),
      calif_ets: vacio(f.calif_ets) ? "" : String(f.calif_ets),
      res: f.resultado || "",
      res_ets: f.resultado_ets || "",
      per_rep: f.periodo_reprobada || "",
      proy: !!f.proyecto_en_curso,
    };
    const id = ID_DE_CLAVE[f.materia] || slotPara(f.materia);
    if (id) state.subjects[id] = Object.assign(state.subjects[id] || {}, rec);
  });

  state.ingreso = d.ingreso || "";

  state.horario = [];
  // Todas las carreras: tu horario puede traer grupos de materias equivalentes.
  const porId = new Map((typeof SCHEDULE !== "undefined" ? SCHEDULE : []).map((e) => [e.id, e]));
  d.horario.forEach((ofId) => {
    const o = porId.get(ofId);
    if (!o) return;
    const id = ID_DE_CLAVE[o.clave] || ID_DE_CLAVE[EQUIV_A_MIA[o.clave]] || slotPara(o.clave);
    if (!id) return;
    const [s, i] = id.slice(1).split("-").map(Number);
    state.horario.push(armarItemHorario(o, s, i));
  });
}

// ---------- guardar en la cuenta cada vez que se guarda local ----------
let _subida = null;
const _saveLocal = save;
save = function () {               // core.js y los demás módulos siguen llamando save()
  _saveLocal();
  if (!USUARIO) return;
  clearTimeout(_subida);
  _subida = setTimeout(subir, 700);
};

async function subir() {
  _subida = null;
  try {
    await apiCuenta("mis-datos.php", datosParaSubir());
    avisoGuardado("Guardado en tu cuenta (" + USUARIO.alias + ").");
  } catch (e) {
    avisoGuardado("No se pudo guardar en tu cuenta: " + e.message, true);
  }
}

// Sube YA lo que hay (sin esperar los 700 ms). Lo usan Reiniciar y Cargar
// respaldo antes de recargar: si no, al recargar se baja lo viejo de la cuenta
// ("la cuenta manda") antes de que llegue el cambio, y los datos regresan.
async function guardarEnCuentaYa() {
  if (!USUARIO) return;
  clearTimeout(_subida);
  _subida = null;
  await apiCuenta("mis-datos.php", datosParaSubir());
}

// Si cierras la pestaña con un cambio aún sin subir, se manda de una vez.
addEventListener("pagehide", () => {
  if (!_subida || !USUARIO) return;
  clearTimeout(_subida);
  const cuerpo = JSON.stringify(datosParaSubir());
  navigator.sendBeacon("api/mis-datos.php", new Blob([cuerpo], { type: "application/json" }));
});

function avisoGuardado(texto, error) {
  const el = document.getElementById("saveState");
  if (!el) return;
  el.textContent = texto;
  el.classList.toggle("save-error", !!error);
}

// ============================================================
//  Entrar y salir
// ============================================================
async function alEntrar(usuario) {
  USUARIO = usuario;
  // La carrera de la cuenta manda: si estás viendo otra, se cambia.
  if (usuario.carrera !== CARRERA) {
    try { localStorage.setItem(CARRERA_KEY, usuario.carrera); } catch (e) { /* sin localStorage */ }
    window.__recargando = true;   // que la bienvenida no se asome antes de recargar
    location.reload();
    return;
  }
  pintarBotonCuenta();
  if (typeof refrescarComentarios === "function") refrescarComentarios();   // la ficha abierta ya te reconoce
  if (typeof cargarAgenda === "function") cargarAgenda();                   // tus recordatorios en el calendario
  try {
    const d = await apiCuenta("mis-datos.php");
    const cuentaVacia = d.avance.length === 0 && d.horario.length === 0 && !d.ingreso;
    const hayLocal = estadoAFilas().length > 0 || state.horario.length > 0 || !!state.ingreso;
    if (cuentaVacia && hayLocal) {
      await subir();               // cuenta nueva: se queda con lo de este navegador
      return;
    }
    // La cuenta manda. El plan se dibuja una sola vez al cargar la página
    // (avance.js), así que si lo de la cuenta es distinto a lo de este
    // navegador se guarda y se recarga una vez (como "Cargar respaldo"). Si
    // es lo mismo, no se toca nada y no hay recarga (ni ciclo).
    const antes = firmaDelEstado();
    const respaldo = { subjects: state.subjects, horario: state.horario, ingreso: state.ingreso };
    aplicarDatos(d);
    if (firmaDelEstado() === antes) {
      state.subjects = respaldo.subjects;
      state.horario = respaldo.horario;
      state.ingreso = respaldo.ingreso;
      avisoGuardado("Tu avance se guarda en tu cuenta (" + usuario.alias + ").");
    } else {
      _saveLocal();
      window.__recargando = true;
      location.reload();
    }
  } catch (e) {
    avisoGuardado("No se pudo leer tu cuenta: " + e.message, true);
  }
}

// Lo que importa del estado, sin depender del orden ni de qué lugar de
// optativa ocupa cada una.
function firmaDelEstado() {
  const filas = estadoAFilas().map((f) => [f.materia, f.veces, f.calif, f.calif_ets, f.resultado, f.resultado_ets, f.periodo_reprobada, f.proyecto_en_curso]).sort();
  return JSON.stringify([filas, horarioAIds().sort((a, b) => a - b), state.ingreso || null]);
}

async function salir() {
  try { await apiCuenta("cuenta/salir.php", {}); } catch (e) { /* igual se limpia */ }
  try { localStorage.removeItem(KEY); } catch (e) { /* sin localStorage */ }
  location.href = location.pathname;
}

function pintarBotonCuenta() {
  mostrarPestanaAdmin();
  cuentaBtnEl.textContent = USUARIO ? "👤 " + USUARIO.alias : "Entrar";
  cuentaBtnEl.title = USUARIO ? "Tu cuenta" : "Entrar o crear cuenta";
  const sel = document.getElementById("carreraSel");
  if (sel) {
    sel.disabled = !!USUARIO;
    sel.title = USUARIO ? "Con sesión iniciada se usa la carrera de tu cuenta" : "";
  }
}

// La pestaña Admin solo aparece para moderadores y admin, y su código
// (admin.js) solo se descarga para ellos. Esconderla NO es la seguridad: cada
// endpoint de api/admin/ revisa en el servidor quién eres.
function mostrarPestanaAdmin() {
  const tab = document.getElementById("tabAdmin");
  const puede = !!USUARIO && USUARIO.rol !== "alumno";
  if (tab) tab.hidden = !puede;
  if (!puede) {
    if (tab && tab.classList.contains("active")) irAPestana("plan");
    return;
  }
  if (!document.querySelector('script[src="admin.js"]')) {
    const s = document.createElement("script");
    s.src = "admin.js";
    document.body.appendChild(s);
  }
}

// ============================================================
//  Ventana de la cuenta
// ============================================================
const OPCIONES_CARRERA = Object.keys(PLANES)
  .map((c) => `<option value="${c}" ${c === CARRERA ? "selected" : ""}>${esc(c + " · " + PLANES[c].nombre)}</option>`)
  .join("");

const VISTAS = {
  entrar: () => ["Entrar", `
    <form class="cuenta-form" data-accion="entrar">
      <label class="campo">Correo<input name="correo" type="email" autocomplete="email" required></label>
      <label class="campo">Contraseña<input name="contrasena" type="password" autocomplete="current-password" required></label>
      <div class="cuenta-msg" role="status"></div>
      <button class="btn btn-primary" type="submit">Entrar</button>
      <div class="cuenta-links">
        <a href="#" data-vista="registro">Crear cuenta</a>
        <a href="#" data-vista="olvide">Olvidé mi contraseña</a>
      </div>
    </form>`],

  registro: () => ["Crear cuenta", `
    <form class="cuenta-form" data-accion="registro">
      <p class="cuenta-nota">Con cuenta, tu avance y tu horario se guardan y los ves desde cualquier
        navegador. Solo pedimos tu correo: nada de boleta, nombre ni teléfono. Tu nombre público es un
        alias al azar que puedes cambiar hasta 3 veces al año, y en cada reseña eliges si sale o si publicas como anónimo.</p>
      <label class="campo">Correo<input name="correo" type="email" autocomplete="email" required></label>
      <label class="campo">Contraseña <small>(mínimo 8 caracteres)</small>
        <input name="contrasena" type="password" autocomplete="new-password" minlength="8" maxlength="72" required></label>
      <label class="campo">Carrera <small>(queda fija)</small><select name="carrera">${OPCIONES_CARRERA}</select></label>
      <div class="cuenta-msg" role="status"></div>
      <button class="btn btn-primary" type="submit">Crear cuenta</button>
      <div class="cuenta-links"><a href="#" data-vista="entrar">Ya tengo cuenta</a></div>
    </form>`],

  olvide: () => ["Olvidé mi contraseña", `
    <form class="cuenta-form" data-accion="olvide">
      <p class="cuenta-nota">Te mandamos un enlace para poner una contraseña nueva.</p>
      <label class="campo">Correo<input name="correo" type="email" autocomplete="email" required></label>
      <div class="cuenta-msg" role="status"></div>
      <button class="btn btn-primary" type="submit">Mandar enlace</button>
      <div class="cuenta-links"><a href="#" data-vista="entrar">Volver</a></div>
    </form>`],

  recuperar: (token) => ["Contraseña nueva", `
    <form class="cuenta-form" data-accion="recuperar" data-token="${esc(token)}">
      <label class="campo">Contraseña nueva <small>(mínimo 8 caracteres)</small>
        <input name="contrasena" type="password" autocomplete="new-password" minlength="8" maxlength="72" required></label>
      <label class="campo">Repítela<input name="otra" type="password" autocomplete="new-password" required></label>
      <div class="cuenta-msg" role="status"></div>
      <button class="btn btn-primary" type="submit">Guardar y entrar</button>
    </form>`],

  miCuenta: () => ["Tu cuenta", `
    <form class="cuenta-form" data-accion="alias">
      <label class="campo">Alias <small>(tu nombre público; sale en tus reseñas)</small>
        <input name="alias" value="${esc(USUARIO.alias)}" minlength="3" maxlength="30" required
               ${USUARIO.alias_cambios_restantes > 0 ? "" : "disabled"}></label>
      <p class="cuenta-nota">${USUARIO.alias_cambios_restantes > 0
        ? `Puedes cambiarlo <b>${USUARIO.alias_cambios_restantes} ${USUARIO.alias_cambios_restantes === 1 ? "vez" : "veces"} más</b> este año (3 al año).`
        : "Ya usaste tus 3 cambios de este año: podrás cambiarlo cuando se cumpla un año del primero."}</p>
      <div class="cuenta-msg" role="status"></div>
      ${USUARIO.alias_cambios_restantes > 0 ? `<button class="btn" type="submit">Cambiar alias</button>` : ""}
    </form>
    <dl class="cuenta-datos">
      <dt>Correo</dt><dd>${esc(USUARIO.correo)} <small>(solo lo ves tú)</small></dd>
      <dt>Carrera</dt><dd>${esc(USUARIO.carrera + " · " + (PLANES[USUARIO.carrera] || {}).nombre)}</dd>
      ${USUARIO.rol !== "alumno" ? `<dt>Rol</dt><dd>${USUARIO.rol === "admin" ? "Administrador" : "Moderador"}</dd>` : ""}
    </dl>
    ${USUARIO.suspendido_hasta ? `<p class="cuenta-msg" data-tipo="error">Tu cuenta está suspendida hasta el
      ${esc(USUARIO.suspendido_hasta)}: puedes usar la app y guardar tu avance, pero no comentar ni reportar.</p>` : ""}
    ${USUARIO.rol !== "alumno" ? `<p><a href="#" class="btn" data-ir-admin="reportes">🛡️ Abrir la pestaña Admin</a></p>` : ""}
    <p class="cuenta-nota">Tu avance y tu horario se guardan en tu cuenta. Al salir se borran de
      este navegador.</p>
    <div class="cuenta-acciones">
      <button class="btn" type="button" data-accion="salir">Salir</button>
      <a href="#" class="cuenta-borrar" data-vista="borrar">Borrar mi cuenta</a>
    </div>`],

  borrar: () => ["Borrar mi cuenta", `
    <form class="cuenta-form" data-accion="borrar">
      <p class="cuenta-nota"><b>Esto no se puede deshacer.</b> Se borran tu correo, tu contraseña,
        tu avance, tu horario, tu agenda y <b>todos tus comentarios</b>. Ese correo no se podrá
        volver a registrar durante 7 días.</p>
      <label class="campo">Escribe tu contraseña para confirmar
        <input name="contrasena" type="password" autocomplete="current-password" required></label>
      <div class="cuenta-msg" role="status"></div>
      <button class="btn btn-danger" type="submit">Borrar mi cuenta para siempre</button>
      <div class="cuenta-links"><a href="#" data-vista="miCuenta">Cancelar</a></div>
    </form>`],
};

function abrirCuenta(vista, arg, mensaje, esError) {
  const [titulo, html] = VISTAS[vista](arg);
  cuentaTitEl.textContent = titulo;
  cuentaBodyEl.innerHTML = html;
  if (mensaje) mostrarMsg(cuentaBodyEl.querySelector(".cuenta-msg"), mensaje, esError);
  if (typeof alAbrirVistaCuenta === "function") alAbrirVistaCuenta(vista);   // comentarios.js
  abrirModal(cuentaEl);
  cuentaBodyEl.querySelector("input")?.focus();
}

function mostrarMsg(el, texto, esError) {
  if (!el) return;
  el.textContent = texto;
  el.dataset.tipo = esError ? "error" : "ok";
}

cuentaBtnEl.addEventListener("click", () => abrirCuenta(USUARIO ? "miCuenta" : "entrar"));
document.getElementById("cuentaCerrar").addEventListener("click", () => cerrarModal(cuentaEl));
cuentaEl.addEventListener("click", (e) => { if (e.target === cuentaEl) cerrarModal(cuentaEl); });
document.addEventListener("keydown", (e) => { if (e.key === "Escape") cerrarModal(cuentaEl); });

cuentaBodyEl.addEventListener("click", (e) => {
  const a = e.target.closest("[data-vista]");
  if (a) { e.preventDefault(); abrirCuenta(a.dataset.vista); return; }
  if (e.target.closest("[data-accion='salir']")) salir();
});

cuentaBodyEl.addEventListener("submit", async (e) => {
  e.preventDefault();
  const form = e.target;
  const msg = form.querySelector(".cuenta-msg");
  const boton = form.querySelector("button[type=submit]");
  const v = Object.fromEntries(new FormData(form));
  boton.disabled = true;
  try {
    switch (form.dataset.accion) {
      case "entrar": {
        const r = await apiCuenta("cuenta/entrar.php", { correo: v.correo, contrasena: v.contrasena });
        cerrarModal(cuentaEl);
        await alEntrar(r.usuario);
        if (typeof revisarBienvenida === "function") revisarBienvenida();   // cuenta todavía vacía
        break;
      }
      case "registro": {
        const r = await apiCuenta("cuenta/registro.php", v);
        form.reset();
        mostrarMsg(msg, r.mensaje + " Ábrelo para activarla y luego entra.");
        break;
      }
      case "olvide": {
        const r = await apiCuenta("cuenta/olvide.php", v);
        mostrarMsg(msg, r.mensaje);
        break;
      }
      case "recuperar": {
        if (v.contrasena !== v.otra) throw new Error("Las dos contraseñas no son iguales.");
        const r = await apiCuenta("cuenta/recuperar.php", { token: form.dataset.token, contrasena: v.contrasena });
        cerrarModal(cuentaEl);
        await alEntrar(r.usuario);
        break;
      }
      case "borrar": {
        await apiCuenta("cuenta/borrar.php", { contrasena: v.contrasena });
        USUARIO = null;                    // que ya no se suba nada
        clearTimeout(_subida);
        try { localStorage.removeItem(KEY); } catch (e2) { /* sin localStorage */ }
        location.href = location.pathname + "?cuenta=borrada";
        break;
      }
      case "alias": {
        const r = await apiCuenta("cuenta/alias.php", { alias: v.alias });
        USUARIO = r.usuario;
        pintarBotonCuenta();
        abrirCuenta("miCuenta", null, "Listo, ahora eres «" + USUARIO.alias + "».");
        break;
      }
    }
  } catch (err) {
    mostrarMsg(msg, err.message, true);
  } finally {
    boton.disabled = false;
  }
});

// ============================================================
//  Arranque: ¿hay sesión? ¿vienes de un enlace del correo?
// ============================================================
(function () {
  const url = new URL(location.href);
  const llegada = url.searchParams.get("cuenta");
  const token = url.searchParams.get("recuperar");
  if (llegada || token) {                 // limpia la barra de direcciones sin recargar
    url.searchParams.delete("cuenta");
    url.searchParams.delete("recuperar");
    history.replaceState(null, "", url.pathname + url.search + url.hash);
  }

  apiCuenta("cuenta/yo.php")
    .then(async (r) => {
      if (r.usuario) await alEntrar(r.usuario);
      else pintarBotonCuenta();
      if (token) abrirCuenta("recuperar", token);
      else if (llegada === "activada" && USUARIO) {
        // Recién creada y vacía: la bienvenida, para capturar de una vez tu avance.
        const abrio = typeof revisarBienvenida === "function" && revisarBienvenida("¡Tu cuenta está activa!");
        if (!abrio) abrirCuenta("miCuenta", null, "¡Tu cuenta está activa! Ya puedes guardar tu avance.");
      }
      else if (llegada === "enlace-vencido") abrirCuenta("entrar", null, "Ese enlace ya se usó o venció. Si no has activado tu cuenta, regístrate otra vez para que te llegue otro.", true);
      else if (llegada === "borrada") abrirCuenta("entrar", null, "Tu cuenta se borró. Puedes seguir usando la app sin cuenta.");
      // Ya se sabe si hay sesión y se bajó tu avance: si sigue vacío, la bienvenida.
      if (!token && !llegada && typeof revisarBienvenida === "function") revisarBienvenida();
    })
    .catch(() => {                       // sin conexión: la app sigue funcionando sin cuenta
      pintarBotonCuenta();
      if (typeof revisarBienvenida === "function") revisarBienvenida();
    });
})();
