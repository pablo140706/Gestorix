// ============================================================
//  CARGA DIFERIDA DE DATOS
// ============================================================
// Los datos vienen de la API (src/api/*.php). No todos hacen falta para el
// primer pintado, y el historial pesa ~320 KB y solo lo usa una pestaña:
//
//   cargarDato(nombre)    -> promesa; pide el dato a la API una sola vez.
//   prefetchDatos([...])  -> lo mismo, pero en cuanto el navegador esté libre.
//
// Qué se carga cuándo:
//   crítico (arranque.js):  planes · horarios · roster · métricas · calendario · optativas
//   prefetch tras el 1.er pintado:  cupos · links de MisProfesores
//   a demanda:  historial  (pestaña Historial y ficha del maestro)
//
// Los nombres ("cupos.js"…) son los de los archivos de iscweb que estos datos
// reemplazan; se conservan para no tocar a quien los pide.

const DATOS_DIFERIDOS = {
  "cupos.js": ["api/cupos.php", (d) => { window.CUPOS = d.actual; window.CUPOS_HIST = d.historial; }],
  "maestros_manual.js": ["api/links.php", (d) => { window.MANUAL_LINKS = d; }],
  "historial.js": ["api/historial.php", (d) => { window.HISTORIAL = d; }],
};

const _lazyProm = {};

function cargarDato(archivo) {
  if (_lazyProm[archivo]) return _lazyProm[archivo];
  const [url, guardar] = DATOS_DIFERIDOS[archivo];
  _lazyProm[archivo] = fetch(url)
    .then((r) => {
      if (!r.ok) throw new Error(url + " respondió " + r.status);
      return r.json();
    })
    .then((datos) => {
      guardar(datos);
      alLlegarDato(archivo);
      return archivo;
    })
    .catch((e) => {
      delete _lazyProm[archivo];               // que un reintento pueda volver a pedirlo
      throw new Error("No se pudo cargar " + url + ": " + e.message);
    });
  return _lazyProm[archivo];
}

// Lo que hay que rehacer cuando un dato diferido por fin llega
function alLlegarDato(archivo) {
  if (archivo === "cupos.js") {
    indexarCupos();
    repintarActiva();
  }
  if (archivo === "maestros_manual.js") {
    loadManualMetrics();                       // ya llama a refreshAfterManual()
  }
}

function prefetchDatos(archivos) {
  const lanzar = () => archivos.forEach((a) => {
    cargarDato(a).catch((e) => console.warn(e.message));
  });
  if ("requestIdleCallback" in window) requestIdleCallback(lanzar, { timeout: 2000 });
  else setTimeout(lanzar, 0);
}

// Vuelve a pintar la pestaña que esté abierta (y la ficha de maestro si está
// encima). Se usa cuando llega un dato que cambia lo que ya está en pantalla.
function repintarActiva() {
  const pane = document.querySelector(".tabpane.active");
  const pintar = pane && {
    "pane-plan": () => render(),
    "pane-maestros": () => renderProfs(),
    "pane-horario": () => renderHorario(),
    "pane-optativas": () => renderOptativas(),
    "pane-historial": () => renderHistorial(),
    "pane-calendario": () => renderCalendario(),
  }[pane.id];
  if (pintar) {
    try { pintar(); } catch (e) { console.warn("repintar " + pane.id, e); }
  }
  if (typeof currentProfDetail !== "undefined" && currentProfDetail &&
      typeof profDetailEl !== "undefined" && profDetailEl && !profDetailEl.hidden) {
    try { showProfDetail(currentProfDetail); } catch (e) { console.warn("repintar ficha", e); }
  }
}
