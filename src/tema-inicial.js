// Tema antes del primer pintado: si esto esperara a tema.js, la página
// parpadearía en claro antes de ponerse oscura. Va en su propio archivo (y
// no dentro de index.html) porque la política de seguridad (CSP) no deja
// correr JavaScript escrito dentro del HTML.
(function () {
  try {
    var t = localStorage.getItem("escom_tema");
    if (!t) t = "claro";   // por defecto CLARO (usuario, 2026-11-21); el botón lo cambia y se recuerda
    document.documentElement.dataset.tema = t;
  } catch (e) { document.documentElement.dataset.tema = "claro"; }
})();
