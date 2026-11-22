// ============================================================
//  SERVICE WORKER — que la app abra sin internet
// ============================================================
// El avance vive en el navegador (localStorage). Esto guarda en caché los
// archivos de la app y las respuestas de la API, así que una vez visitada,
// la app abre en el metro aunque no haya conexión.
//
// Estrategia: **red primero, caché de respaldo** para todo lo propio.
//
// Lo intuitivo sería caché primero (más rápido), y así estaba al principio.
// Duró diez minutos: editas styles.css, recargas y sigues viendo el viejo,
// porque el service worker te sirve su copia sin preguntar. Mientras el
// proyecto se siga editando todos los días, eso cuesta más de lo que ahorra.
// Sin conexión el respaldo entra igual, que es para lo que está esto.
//
// La excepción son las fuentes de Google: esas sí van caché primero, porque
// vienen con hash en la URL y no cambian nunca.

const VERSION = "v19";
const CACHE = "gestorix-" + VERSION;

// El mínimo para pintar: los archivos de la app y los datos críticos de la
// API. Lo diferido (api/cupos.php, api/links.php, api/historial.php) entra
// solo a la caché la primera vez que la app lo pide.
const SHELL = [
  "./",
  "index.html",
  "styles.css",
  "favicon.svg", "icono-192.png", "icono-512.png",
  "manifest.webmanifest",
  "arranque.js", "tema-inicial.js",
  "api/planes.php", "api/horarios.php", "api/roster.php", "api/metricas.php",
  "api/calendario.php", "api/optativas.php",
  "lazy.js", "data.js", "core.js", "materia-ui.js", "avance.js", "maestros.js", "horario.js",
  "optativas-ui.js", "auto.js", "export.js", "historial-ui.js", "calendario-ui.js",
  "carrera-ui.js", "tema.js", "buscador.js", "comparador.js", "compartir.js",
  "atajos.js", "portada.js", "init.js", "bienvenida.js", "cuenta.js", "comentarios.js", "agenda.js",
];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(CACHE)
      // addAll falla entero si un archivo falla; uno a uno es más tolerante
      .then((c) => Promise.allSettled(SHELL.map((u) => c.add(u))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys()
      .then((ks) => Promise.all(ks.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.method !== "GET") return;

  const url = new URL(req.url);
  const propio = url.origin === location.origin;
  const fuentes = /fonts\.(googleapis|gstatic)\.com$/.test(url.hostname);
  if (!propio && !fuentes) return;

  // Lo de tu cuenta (quién eres, tu avance, tu agenda) nunca se guarda en la
  // caché: en una compu compartida lo vería el siguiente. La ficha del
  // profesor tampoco: trae tus comentarios ocultos y lo que ya reportaste.
  if (propio && /\/api\/(cuenta\/|mis-datos|agenda|profesor|comentarios\/|moderacion\/)/.test(url.pathname)) return;

  // Fuentes de Google: caché primero, no cambian nunca
  if (fuentes) {
    e.respondWith(
      caches.match(req).then((hit) => hit || fetch(req).then((r) => {
        if (r && r.ok) { const copia = r.clone(); caches.open(CACHE).then((c) => c.put(req, copia)); }
        return r;
      }))
    );
    return;
  }

  // Lo propio: red primero; si no hay conexión, lo último que se guardó
  e.respondWith(
    fetch(req)
      .then((r) => {
        if (r && r.ok) {
          const copia = r.clone();
          caches.open(CACHE).then((c) => c.put(req, copia));
        }
        return r;
      })
      .catch(() => caches.match(req).then((hit) =>
        hit || (req.mode === "navigate" ? caches.match("index.html") : undefined)))
  );
});
