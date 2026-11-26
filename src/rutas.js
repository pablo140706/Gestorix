// ============================================================
//  RUTAS — cada vista tiene su dirección
// ============================================================
// Antes toda la app vivía en "/": cambiar de pestaña no tocaba la URL, así
// que abrir en otra ventana, compartir un maestro o darle Atrás siempre te
// devolvía al inicio (usuario, 2026-11-26). Ahora:
//
//   /                      Mi avance (y la portada, la primera vez)
//   /maestros              la lista de maestros
//   /maestro/<nombre>      la ficha de un maestro
//   /horario · /optativas · /historial · /calendario
//
// Cómo funciona: Apache manda **cualquier** ruta que no sea un archivo a
// index.html (apache/seguridad.conf), la app arranca igual que siempre y
// aquí decidimos qué pintar. Por eso index.html lleva <base href="/">: sin
// eso, en /maestro/x el navegador buscaría /maestro/styles.css.
//
// La pestaña Admin NO tiene dirección, a propósito: que no quede rastro de
// que existe. Los horarios compartidos siguen viajando en el hash (#h=…),
// que es otra cosa y no se toca.
//
// Buscadores: index.html lleva noindex y hay robots.txt. Las fichas son
// enlazables, pero no salen en Google (usuario, 2026-11-26).

// Pestaña ↔ ruta. "plan" (Mi avance) es la raíz.
const RUTA_DE_TAB = {
  plan: "/",
  maestros: "/maestros",
  horario: "/horario",
  optativas: "/optativas",
  historial: "/historial",
  calendario: "/calendario",
};
const TAB_DE_RUTA = Object.fromEntries(
  Object.entries(RUTA_DE_TAB).map(([tab, ruta]) => [ruta, tab]).concat([["/avance", "plan"]])
);

// Mientras el enrutador pinta, nadie vuelve a empujar al historial.
let aplicandoRuta = false;

// ---------- nombre del maestro ↔ texto de la dirección ----------
// "SÁNCHEZ MORENO ADRIANA DE LA P" → "sanchez-moreno-adriana-de-la-p".
// Usa el mismo norm() que cruza nombres en toda la app (sin acentos, Ñ→N).
function slugDeMaestro(nombre) {
  return norm(nombre).toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");
}

// slug → nombre. Si dos maestros dieran el mismo texto (solo pasaría si se
// distinguen por puntuación), el segundo lleva -2, -3… por orden alfabético,
// para que la dirección de cada uno sea siempre la misma.
const MAESTRO_DE_SLUG = (() => {
  const mapa = {};
  const usados = {};
  // TEACHERS trae objetos { name, materias, grupos… } (core.js, allTeachers).
  const nombres = (typeof TEACHERS !== "undefined" ? TEACHERS : []).map((t) => t.name).sort();
  nombres.forEach((nombre) => {
    const base = slugDeMaestro(nombre);
    if (!base) return;
    usados[base] = (usados[base] || 0) + 1;
    mapa[usados[base] === 1 ? base : base + "-" + usados[base]] = nombre;
  });
  return mapa;
})();
const SLUG_DE_MAESTRO = Object.fromEntries(
  Object.entries(MAESTRO_DE_SLUG).map(([slug, nombre]) => [nombre, slug])
);

function rutaDeMaestro(nombre) {
  const slug = SLUG_DE_MAESTRO[nombre] || slugDeMaestro(nombre);
  return slug ? "/maestro/" + slug : null;
}

// ---------- leer la dirección ----------
// Devuelve { tab }, { maestro } o { desconocida }. No distingue mayúsculas ni
// la diagonal final: /Historial/ y /historial son la misma vista, y la barra
// se corrige sola a la forma canónica.
function rutaActual() {
  const p = decodeURIComponent(location.pathname).replace(/\/+$/, "").toLowerCase() || "/";
  if (TAB_DE_RUTA[p]) return { tab: TAB_DE_RUTA[p] };
  const m = /^\/maestro\/(.+)$/.exec(p);
  if (m) {
    const nombre = MAESTRO_DE_SLUG[m[1]];
    return nombre ? { maestro: nombre } : { desconocida: p };
  }
  return p === "/" ? { tab: "plan" } : { desconocida: p };
}

// La dirección que le corresponde a una vista, para corregir la barra cuando
// lo que escribieron no es exactamente la forma canónica.
function rutaCanonica(r) {
  if (r.maestro) return rutaDeMaestro(r.maestro);
  return RUTA_DE_TAB[r.tab] || "/";
}

function hayRutaEnURL() {
  const r = rutaActual();
  return !!(r.maestro || (r.tab && r.tab !== "plan"));
}

// ---------- escribir la dirección ----------
function tituloDeRuta(r) {
  if (r.maestro) return r.maestro + " — Gestorix";
  const nombres = {
    plan: "Mi avance", maestros: "Maestros", horario: "Generar horario",
    optativas: "Optativas", historial: "Historial", calendario: "Calendario",
  };
  return (nombres[r.tab] ? nombres[r.tab] + " — " : "") + "Gestorix";
}

// Empuja una ruta nueva al historial (así el botón Atrás recorre lo que
// visitaste). Si ya estamos en esa misma dirección, no duplica.
function rutaEmpujar(ruta, r) {
  if (!ruta || aplicandoRuta) return;
  const actual = location.pathname.replace(/\/+$/, "") || "/";
  document.title = tituloDeRuta(r || rutaActual());
  if (actual === ruta) return;
  // Sin el hash a propósito: si venías de un horario compartido (#h=…) y te
  // mueves a otra vista, ese horario ya no es lo que estás viendo, y arrastrar
  // el hash dejaría enlaces como /maestros#h=… que al abrirlos mandan al
  // horario. Al aterrizar uno compartido no se pasa por aquí (init.js).
  history.pushState(null, "", ruta + location.search);
}

// Las llaman irAPestana() (avance.js) y showProfDetail() (maestros.js).
function rutaDePestana(tab) {
  if (tab === "admin") return;                 // Admin no tiene dirección
  rutaEmpujar(RUTA_DE_TAB[tab], { tab });
}
function rutaDeFicha(nombre) {
  rutaEmpujar(rutaDeMaestro(nombre), { maestro: nombre });
}

// ---------- pintar lo que diga la dirección ----------
function aplicarRuta() {
  let r = rutaActual();
  // Dirección que no existe: se entra por la puerta grande, sin dejar el
  // rastro roto en el historial.
  if (r.desconocida) r = { tab: "plan" };

  // Si la portada está encima y la dirección pide una vista concreta (porque
  // le diste Atrás después de pulsar 🏠, o abriste un enlace), la portada
  // estorba: se entra a la app. En la raíz no, que ahí la portada es la vista.
  const pideVista = !!r.maestro || r.tab !== "plan";
  if (pideVista && typeof portadaEl !== "undefined" && portadaEl && !portadaEl.hidden
      && typeof entrarApp === "function") {
    entrarApp();
  }

  aplicandoRuta = true;
  try {
    if (r.maestro) {
      showProfDetail(r.maestro);
    } else {
      if (typeof hideProfDetail === "function") hideProfDetail();
      pintarPestana(r.tab);
    }
    // Deja en la barra la forma canónica: corrige mayúsculas, diagonal final,
    // /avance → / y las direcciones que no existen.
    const canonica = rutaCanonica(r);
    const actual = location.pathname.replace(/\/+$/, "") || "/";
    if (canonica && canonica !== actual) {
      history.replaceState(null, "", canonica + location.search + location.hash);
    }
    // Con la portada encima (primera visita), el título es el del sitio: lo
    // que se ve no es Mi avance todavía.
    const conPortada = typeof portadaEl !== "undefined" && portadaEl && !portadaEl.hidden;
    document.title = conPortada && !pideVista
      ? "Gestorix — avance, maestros y horario de ESCOM"
      : tituloDeRuta(r);
  } finally {
    aplicandoRuta = false;
  }
}

// Al cargar la página: pinta lo que diga la dirección.
function aplicarRutaInicial() {
  aplicarRuta();
}

// Atrás y Adelante del navegador.
addEventListener("popstate", aplicarRuta);

// La portada (🏠 o la tecla H) es la puerta de entrada: su dirección es la
// raíz, así lo que ves y lo que dice la barra coinciden, y recargar desde ahí
// no te devuelve a la vista que acabas de dejar.
function rutaPortada() {
  rutaEmpujar("/", { tab: "plan" });
  document.title = "Gestorix — avance, maestros y horario de ESCOM";
}

// Al entrar a la app desde la portada, el título pasa a ser el de la vista.
function rutaEntrar() {
  document.title = tituloDeRuta(rutaActual());
}

// Volver a la lista desde la ficha de un maestro (botón ← de la ficha).
function volverAListaDeMaestros() {
  hideProfDetail();
  rutaEmpujar(RUTA_DE_TAB.maestros, { tab: "maestros" });
}
