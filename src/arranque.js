// ============================================================
//  ARRANQUE — primero los datos de la API, luego la app
// ============================================================
// En iscweb los datos venían en archivos .js (planes.js, schedule.js…) que
// se cargaban con <script> antes que la app. En Gestorix vienen de la base
// de datos por la API (src/api/*.php), en JSON. Este archivo:
//
//   1. pide a la API los datos que hacen falta para el primer pintado;
//   2. los deja en las MISMAS variables globales de antes (PLANES,
//      SCHEDULE…), así el resto del código no tuvo que cambiar;
//   3. y hasta entonces carga los módulos de la app, en el orden de siempre.
//
// Lo que no hace falta para el primer pintado (cupos, links, historial) lo
// sigue pidiendo lazy.js cuando se necesita.

(function () {
  // variable global → endpoint
  const DATOS = {
    PLANES: "api/planes.php",
    SCHEDULE: "api/horarios.php",
    ROSTER: "api/roster.php",
    TEACHER_METRICS: "api/metricas.php",
    CALENDARIO: "api/calendario.php",
    ESPECIALIZACIONES: "api/optativas.php",
  };

  // El orden importa: cada módulo usa lo que definieron los anteriores.
  const MODULOS = [
    "lazy.js", "data.js", "core.js", "materia-ui.js", "avance.js", "maestros.js", "horario.js",
    "optativas-ui.js", "auto.js", "export.js", "historial-ui.js", "calendario-ui.js",
    "carrera-ui.js", "tema.js", "buscador.js", "comparador.js", "compartir.js",
    "rutas.js", "atajos.js", "portada.js", "init.js", "bienvenida.js", "cuenta.js", "comentarios.js", "agenda.js",
  ];

  function pedir(url) {
    return fetch(url).then((r) => {
      if (!r.ok) throw new Error(url + " respondió " + r.status);
      return r.json();
    });
  }

  function cargarModulos() {
    MODULOS.forEach((src) => {
      const s = document.createElement("script");
      s.src = src;
      s.async = false;   // los <script> agregados así se ejecutan en el orden en que se agregan
      document.body.appendChild(s);
    });
  }

  function avisarError() {
    const aviso = document.createElement("div");
    aviso.setAttribute("role", "alert");
    aviso.style.cssText =
      "margin:2rem auto;max-width:32rem;padding:1rem 1.25rem;border-radius:12px;" +
      "background:#fee2e2;color:#7f1d1d;font:500 1rem/1.5 Inter,system-ui,sans-serif;text-align:center";
    aviso.textContent =
      "No se pudieron cargar los datos de Gestorix. Revisa tu conexión y recarga la página.";
    document.body.prepend(aviso);
  }

  Promise.all(
    Object.entries(DATOS).map(([nombre, url]) =>
      pedir(url).then((datos) => { window[nombre] = datos; }))
  )
    .then(cargarModulos)
    .catch((e) => {
      console.error("Gestorix: no se pudieron cargar los datos", e);
      avisarError();
    });
})();
