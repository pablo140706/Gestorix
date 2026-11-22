// =====================================================================
//  Pruebas de las reglas de negocio de Gestorix (sin navegador).
// =====================================================================
//  Carga src/data.js y src/core.js TAL CUAL, en un contexto aislado de Node,
//  con los planes de pruebas/planes.json, y revisa las reglas que más se
//  pueden romper con un cambio: promedio, desfase, ventana de semestres,
//  carga, regulares y grupos de recurse.
//
//  Correr (en la carpeta del proyecto; usa la imagen de Node de Docker):
//      docker run --rm -v "${PWD}:/app" -w /app node:22-alpine node pruebas/reglas.test.js
//  En Git Bash:
//      MSYS_NO_PATHCONV=1 docker run --rm -v "$(pwd -W):/app" -w /app node:22-alpine node pruebas/reglas.test.js
//
//  Si después de un cambio algo sale ❌, o la regla cambió a propósito (y
//  hay que actualizar la prueba) o el cambio rompió algo.
// =====================================================================

const fs = require("fs");
const path = require("path");
const vm = require("vm");

const raiz = path.join(__dirname, "..");
const almacen = {};
const ctx = vm.createContext({
  console,
  PLANES: JSON.parse(fs.readFileSync(path.join(__dirname, "planes.json"), "utf8")),
  localStorage: {
    getItem: (k) => (k in almacen ? almacen[k] : null),
    setItem: (k, v) => { almacen[k] = String(v); },
    removeItem: (k) => { delete almacen[k]; },
  },
  ROSTER: [], SCHEDULE: [], TEACHER_METRICS: {},
});
for (const f of ["data.js", "core.js"]) {
  vm.runInContext(fs.readFileSync(path.join(raiz, "src", f), "utf8"), ctx, { filename: f });
}
const js = (codigo) => vm.runInContext(codigo, ctx);

// El "hoy" de las pruebas: 27/1 (ago–dic 2026), para que no dependan de la fecha.
js(`_periodoActual = "27/1"`);

let bien = 0, mal = 0;
function prueba(nombre, obtenido, esperado) {
  const ok = JSON.stringify(obtenido) === JSON.stringify(esperado);
  if (ok) bien++; else mal++;
  console.log(`${ok ? "✅" : "❌"} ${nombre}${ok ? "" : `\n     esperado: ${JSON.stringify(esperado)}\n     obtenido: ${JSON.stringify(obtenido)}`}`);
}

// Avance de ejemplo: por clave oficial → se traduce a la posición del plan.
function con(avance, horario = []) {
  js(`state.subjects = {}; state.horario = [];`);
  for (const [clave, rec] of Object.entries(avance)) {
    js(`state.subjects[ID_DE_CLAVE[${JSON.stringify(clave)}]] = ${JSON.stringify(rec)}`);
  }
  for (const clave of horario) js(`state.horario.push({ sid: ID_DE_CLAVE[${JSON.stringify(clave)}], cred: 7.5 })`);
}
function promedio() {
  return js(`(() => {
    let s = 0, n = 0;
    PLAN.forEach((b, si) => b.materias.forEach(([nom], i) => {
      const c = califParaPromedio(getSub(idOf(si, i), nom)); if (c !== null) { s += c; n++; }
    }));
    return n ? (s / n).toFixed(2) : "—";
  })()`);
}
const estado = (clave) => js(`getSub(ID_DE_CLAVE[${JSON.stringify(clave)}], "")`);

// Kárdex de ejemplo: dos recurses (uno aprobado y uno reprobado), una reprobada en ordinario y dos aprobadas.
const kardex = {
  C101: { veces: 2, calif: "7" }, C103: { veces: 2, calif: "5", per_rep: "26/1" },
  C104: { veces: 1, calif: "5", per_rep: "26/1" }, C105: { veces: 1, calif: "7" }, C205: { veces: 1, calif: "10" },
};

console.log("\n— Promedio (como el Kárdex: última calificación, aprobada o reprobada) —");
con(kardex);
prueba("el Kárdex de ejemplo: (7 + 5 + 5 + 7 + 10) / 5 = 6.80", promedio(), "6.80");
con({ C104: { calif: "5", calif_ets: "8" }, C105: { calif: "7" } });
prueba("aprobada por ETS cuenta la del ETS (8), no la del curso (5)", promedio(), "7.50");
con({ C104: { res: "aprobada" }, C105: { calif: "9" } });
prueba("aprobada sin número no entra al promedio", promedio(), "9.00");
con({ C104: { res: "aprobada" } });
prueba("sin ningún número, el promedio es —", promedio(), "—");

console.log("\n— Estado de cada materia —");
con(kardex);
prueba("Cálculo: recurse reprobado → solo por ETS", [estado("C103").status, estado("C103").soloEts], ["reprobada", true]);
prueba("Análisis vectorial: 1.ª vez reprobada → todavía se puede recursar", [estado("C104").soloEts, js(`canInscribir(getSub(ID_DE_CLAVE.C104, ""))`)], [false, true]);
prueba("Fundamentos: recurse con 7 → aprobada", estado("C101").status, "aprobada");
con({ C102: { res: "aprobada" } });
prueba("aprobada sin número cuenta como aprobada", estado("C102").status, "aprobada");

console.log("\n— Periodos y desfase (desde el ordinario; hoy = 27/1) —");
prueba("27/1 ↔ número y de regreso", js(`numAPer(perANum("27/1"))`), "27/1");
prueba("28/2 termina en jun 2028", js(`perFin("28/2")`), "jun 2028");
prueba("25/1 empieza en ago 2024", js(`perInicio("25/1")`), "ago 2024");
prueba("reprobada en 26/2 → a tiempo", js(`desfaseDe("26/2")`), "");
prueba("reprobada en 26/1 → 3.er semestre, último", js(`desfaseDe("26/1")`), "ultimo");
prueba("reprobada en 25/2 → desfasada, carta de 24 créditos", js(`desfaseDe("25/2")`), "carta24");
prueba("reprobada en 25/1 → dictamen", js(`desfaseDe("25/1")`), "dictamen");

console.log("\n— Ventana de 3 semestres desde lo más bajo que debes —");
con(kardex);
prueba("debe de 1.º → de 1.º a 3.º", js(`ventanaInscripcion()`), { lo: 1, hi: 3 });
con({ C101: { calif: "8" }, C102: { calif: "8" }, C103: { calif: "8" }, C104: { calif: "8" }, C105: { calif: "8" } });
prueba("1.º completo → de 2.º a 4.º", js(`ventanaInscripcion()`), { lo: 2, hi: 4 });

console.log("\n— Carga: las reprobadas ocupan carga hasta aprobarlas —");
con(kardex);
prueba("Cálculo y Análisis vectorial ocupan 2 UA sin estar en el horario", js(`uaBloqueadas()`), 2);
con(kardex, ["C104"]);
prueba("si Análisis vectorial está en el horario, no se cuenta doble", js(`uaBloqueadas()`), 1);

console.log("\n— Regulares e irregulares —");
con({});
prueba("sin nada capturado → regular", js(`esRegular()`), true);
con(kardex);
prueba("con reprobadas → irregular, su máximo es la media (7)", [js(`esRegular()`), js(`cargaMaxPermitida()`)], [false, 7]);
con({ C201: { calif: "9" } });
prueba("aprobó de 2.º pero debe de 1.º → irregular", js(`esRegular()`), false);

console.log("\n— Grupos de recurse (solo 1.er semestre) —");
prueba("1CM6 es regular", js(`esGrupoRecurse("1CM6")`), false);
prueba("1CM7 es de recurse", js(`esGrupoRecurse("1CM7")`), true);
prueba("1CV5 es regular", js(`esGrupoRecurse("1CV5")`), false);
prueba("1CV6 es de recurse", js(`esGrupoRecurse("1CV6")`), true);
prueba("2CM6 es regular (en 2.º no hay grupos de recurse)", js(`esGrupoRecurse("2CM6")`), false);

console.log("\n— Equivalencias con otras carreras (SAES) —");
prueba("Cálculo de ISC equivale a A104 y B104", js(`EQUIV.C103`), ["A104", "B104"]);
prueba("el grupo de IA de B104 cuenta como tu Cálculo", js(`EQUIV_A_MIA.B104`), "C103");

console.log(`\n${mal ? "❌" : "✅"} ${bien} bien, ${mal} mal\n`);
process.exit(mal ? 1 : 0);
