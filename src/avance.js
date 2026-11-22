// ============================================================
//  PESTAÑAS
// ============================================================
const tabsEl = document.getElementById("tabs");

// Abre una pestaña por su nombre. Está suelto (y no dentro del onclick) porque
// el buscador global y los atajos de teclado también necesitan saltar de pestaña.
function irAPestana(tab) {
  tabsEl.querySelectorAll(".tab").forEach((b) => b.classList.toggle("active", b.dataset.tab === tab));
  document.querySelectorAll(".tabpane").forEach((p) => {
    p.classList.toggle("active", p.id === "pane-" + tab);
  });
  if (tab !== "maestros" && typeof hideProfDetail === "function") hideProfDetail();
  if (tab === "plan") render();
  if (tab === "maestros") renderProfs();
  if (tab === "horario") renderHorario();
  if (tab === "optativas") renderOptativas();
  if (tab === "historial") renderHistorial();
  if (tab === "calendario") renderCalendario();
}

tabsEl.querySelectorAll(".tab").forEach((btn) => {
  btn.onclick = () => irAPestana(btn.dataset.tab);
});

// ============================================================
//  PESTAÑA 1 · AVANCE
// ============================================================
const chipDefs = [
  ["todas", "Todas"], ["aprobada", "Aprobadas"],
  ["reprobada", "Reprobadas"], ["pendiente", "Pendientes"],
];
let filter = "todas";
const chipsEl = document.getElementById("chips");
chipDefs.forEach(([k, label]) => {
  const b = document.createElement("button");
  b.className = "chip";
  b.dataset.k = k;
  b.setAttribute("aria-pressed", k === "todas");
  b.innerHTML = `<span class="dot ${k}"></span>${label} <span class="n num" data-c="${k}">0</span>`;
  b.onclick = () => { filter = k; render(); };
  chipsEl.appendChild(b);
});

const planEl = document.getElementById("plan");

PLAN.forEach((blk, s) => {
  const sec = document.createElement("section");
  sec.className = "sem";
  sec.dataset.sem = s;
  const total = blk.materias.reduce((a, m) => a + m[1], 0);
  sec.innerHTML = `
    <div class="semhead">
      <span class="semtitle">${blk.sem}</span>
      <span class="semmeta">
        <span><b class="semOk">0</b>/${blk.materias.length} aprobadas</span>
        <span class="minibar"><i class="semFill"></i></span>
        <span><b>${total}</b> cr</span>
      </span>
    </div>
    <div class="rows"></div>`;
  const rowsEl = sec.querySelector(".rows");

  blk.materias.forEach(([name, cred], i) => {
    const id = idOf(s, i);
    const rec = getSub(id, name);
    const isOpt = !!OPT_SLOTS[id];

    const subj = document.createElement("div");
    subj.className = "subject";
    subj.dataset.id = id;

    subj.innerHTML = `
      <div class="row">
        <span class="name">${esc(rec.name)}${isOpt ? `<span class="opttag">${OPT_SLOTS[id].label}</span>` : ""}${difBadge(name)}${botonMateria(CLAVE_DE_ID[id] || rec.clave)}</span>
        <span class="cred">${cred}</span>
        <div class="row-controls">
          <select class="veces" aria-label="Veces cursada de ${esc(name)}">
            <option value="1">1ª vez</option>
            <option value="2">2ª (recurse)</option>
          </select>
          <select class="calif" aria-label="Calificación de ${esc(name)}"
                  title="Calificación. Si no quieres dar el número, elige Aprobada o Reprobada">${opcionesCalif("curso")}</select>
          <select class="calif ets" aria-label="Calificación del ETS de ${esc(name)}"
                  title="ETS (examen a título de suficiencia). Puedes poner el número o solo si lo aprobaste">${opcionesCalif("ets")}</select>
          <span class="status-badge" data-st="${rec.status}" data-blocked="${rec.soloEts ? "1" : "0"}" data-recurse="${esEnRecurse(rec) ? "1" : "0"}" data-inscrita="${rec.status === "pendiente" && estaInscrita(id) ? "1" : "0"}">${statusBadgeText(rec, estaInscrita(id))}</span>
          <button class="profsBtn" type="button">Maestros <span class="caret">▾</span></button>
        </div>
      </div>
      <div class="drop"></div>`;

    const vecesSel = subj.querySelector("select.veces");
    const calif = subj.querySelector(".calif");
    const ets = subj.querySelector(".ets");
    const badge = subj.querySelector(".status-badge");
    const profsBtn = subj.querySelector(".profsBtn");
    const drop = subj.querySelector(".drop");

    vecesSel.value = String(rec.veces);
    calif.value = valorCalif(rec, "curso");
    ets.value = valorCalif(rec, "ets");
    applyRowMode(subj, rec);

    // Después de cualquier cambio: recalcular el estado, y si la materia ya
    // no se puede inscribir (aprobada, o solo por ETS) sacarla del horario.
    const tras = () => {
      Object.assign(rec, getSub(id, name));
      vecesSel.value = String(rec.veces);
      calif.value = valorCalif(rec, "curso");
      ets.value = valorCalif(rec, "ets");
      applyRowMode(subj, rec);
      if (!canInscribir(rec)) {
        const antes = state.horario.length;
        state.horario = state.horario.filter((h) => h.sid !== id);
        if (state.horario.length !== antes) save();
        drop.classList.remove("open");
      }
      render();
    };
    subj._tras = tras;   // bienvenida.js la usa al terminar la ventana de reprobadas

    // Cambiar de 1.ª a 2.ª vez (o al revés) es otro curso: el ETS que se
    // haya presentado era del curso anterior y se borra.
    vecesSel.onchange = () => {
      setSub(id, { veces: Number(vecesSel.value), calif_ets: "", res_ets: "" });
      tras();
    };

    calif.onchange = () => {
      const antes = rec.reproboCurso;
      const patch = patchCalif(calif.value, "curso");
      // Solo hay ETS si reprobaste el curso.
      if (!(patch.res === "reprobada" || (patch.calif !== "" && Number(patch.calif) < 6))) {
        patch.calif_ets = ""; patch.res_ets = "";
      }
      setSub(id, patch);
      tras();
      // Recién reprobada: que diga en qué situación quedó (bienvenida.js).
      if (rec.reproboCurso && !antes && typeof abrirSituacion === "function") abrirSituacion(id, rec.name);
    };

    ets.onchange = () => {
      setSub(id, patchCalif(ets.value, "ets"));
      tras();
    };

    profsBtn.onclick = () => {
      const willOpen = !drop.classList.contains("open");
      if (willOpen) {
        renderDrop(drop, s, i);
        drop.classList.add("open");
        profsBtn.classList.add("active");
      } else {
        drop.classList.remove("open");
        profsBtn.classList.remove("active");
      }
    };

    rowsEl.appendChild(subj);
  });

  planEl.appendChild(sec);
});

// ---- Calificación: número del 0 al 10, o solo "aprobada"/"reprobada" ----
// Para quien no quiere dar sus calificaciones (privacidad): sin número la
// materia cuenta para créditos y avance, pero no para el promedio.
// En la lista: "" = sin calificar · "A" = aprobada · "R" = reprobada · "0"–"10".
function opcionesCalif(tipo) {
  const ets = tipo === "ets";
  const nums = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0].map((n) => `<option value="${n}">${n}</option>`).join("");
  return `<option value="">${ets ? "ETS" : "Cal"}</option>
    <optgroup label="Sin número"><option value="A">${ets ? "Aprobado" : "Aprobada"}</option><option value="R">${ets ? "Reprobado" : "Reprobada"}</option></optgroup>
    <optgroup label="Calificación">${nums}</optgroup>`;
}
function valorCalif(rec, tipo) {
  const num = tipo === "ets" ? rec.calif_ets : rec.calif;
  if (num !== "") return String(num);
  const res = tipo === "ets" ? rec.res_ets : rec.res;
  return res ? res[0].toUpperCase() : "";
}
function patchCalif(valor, tipo) {
  const ets = tipo === "ets";
  const num = ets ? "calif_ets" : "calif", res = ets ? "res_ets" : "res";
  if (valor === "A") return { [num]: "", [res]: ets ? "aprobado" : "aprobada" };
  if (valor === "R") return { [num]: "", [res]: ets ? "reprobado" : "reprobada" };
  return { [num]: valor, [res]: "" };
}

// Pone en cada fila lo que hay en `state` (tras marcar varias de golpe).
function sincronizarFilas() {
  planEl.querySelectorAll(".subject").forEach((subj) => {
    const m = subj.dataset.id.match(/^s(\d+)-(\d+)$/);
    if (!m) return;
    const id = subj.dataset.id;
    const def = PLAN[+m[1]].materias[+m[2]][0];
    const rec = getSub(id, def);
    // Un lugar de optativa que ya tiene optativa (p. ej. importada del Kárdex) muestra su nombre.
    if (OPT_SLOTS[id] && state.subjects[id] && state.subjects[id].clave) {
      subj.querySelector(".name").innerHTML = esc(rec.name) + `<span class="opttag">${OPT_SLOTS[id].label}</span>` +
        difBadge(def) + botonMateria(state.subjects[id].clave);
    }
    subj.querySelector("select.veces").value = String(rec.veces);
    subj.querySelector("select.calif:not(.ets)").value = valorCalif(rec, "curso");
    subj.querySelector("select.ets").value = valorCalif(rec, "ets");
  });
  render();
}

// Muestra calif (aprobada/reprobada) u oculta; el botón Maestros aparece en pendiente y reprobada
function applyRowMode(subj, rec) {
  const id = subj.dataset.id;
  const inscrita = rec.status === "pendiente" && estaInscrita(id);
  const profsBtn = subj.querySelector(".profsBtn");
  const badge = subj.querySelector(".status-badge");
  badge.dataset.st = rec.status;
  badge.dataset.blocked = rec.soloEts ? "1" : "0";
  // El campo de ETS solo aparece si reprobaste el curso (ordinario o recurse).
  const ets = subj.querySelector(".ets");
  if (ets) ets.hidden = !rec.reproboCurso;
  badge.dataset.recurse = esEnRecurse(rec) ? "1" : "0";
  badge.dataset.inscrita = inscrita ? "1" : "0";
  badge.dataset.desfase = rec.desfase || "";
  badge.title = rec.desfase ? `Reprobada en ${rec.per_rep}. ${TEXTO_DESFASE[rec.desfase]}`
    : rec.per_rep ? `Reprobada en ${rec.per_rep}` : "";
  badge.textContent = statusBadgeText(rec, inscrita);
  // Profes solo visible si se puede inscribir
  const inscribible = canInscribir(rec);
  profsBtn.classList.toggle("hidden", !inscribible);
  if (!inscribible) {
    const drop = subj.querySelector(".drop");
    drop.classList.remove("open");
    profsBtn.classList.remove("active");
  }
}

// Despliega la lista de ofertas reales (SCHEDULE) con días/horas, salón y métricas
function renderDrop(drop, s, i) {
  const id = idOf(s, i);
  // Los grupos de materias equivalentes de otras carreras van escondidos;
  // "Mostrar equivalencias" los agrega (usuario, 2026-11-21).
  const propias = scheduleFor(s, i, false);
  const equivalentes = scheduleFor(s, i).filter((e) => e.carrera !== CARRERA);
  const conEq = drop.dataset.eq === "1";
  const list = conEq ? propias.concat(equivalentes) : propias;
  const cred = PLAN[s].materias[i][1];
  const isOpt = !!OPT_SLOTS[id];
  const eqBtn = equivalentes.length
    ? `<button class="eqBtn" type="button" title="Grupos de la materia equivalente en otras carreras; cuentan como esta">${conEq ? "Ocultar" : "Mostrar"} equivalencias (${equivalentes.length})</button>`
    : "";

  if (list.length === 0) {
    drop.innerHTML = `<div class="drop-empty">No hay grupos abiertos de tu carrera este semestre para esta materia. ${eqBtn}</div>`;
    drop.querySelector(".eqBtn")?.addEventListener("click", () => { drop.dataset.eq = conEq ? "" : "1"; renderDrop(drop, s, i); });
    return;
  }

  drop.innerHTML = `
    <div class="drop-head">
      <span>${list.length} ofert${list.length === 1 ? "a" : "as"} este semestre · elige una para sumarla a tu horario</span>
      ${eqBtn}
      ${list.length > 1 ? `<button class="cmpBtn" data-cmp="${s}-${i}">⚖️ Comparar maestros</button>` : ""}
    </div>
    <details class="drop-nota"><summary>¿Cómo funciona el cupo y el sobrecupo?</summary>${esc(NOTA_CUPO)}</details>
    <div class="drop-list">
      ${list.map((e, k) => {
        const m = getMetric(e.profesor);
        const inH = state.horario.some(
          (h) => h.sid === id && h.maestro === e.profesor && (h.grupo || "") === e.grupo
        );
        const rama = e.materia.includes("|") ? e.materia.split("|")[0].trim() : "";
        const turno = turnoDeGrupo(e.grupo);
        const turnoChip = turno === "V"
          ? `<span class="tchip tv">🌙 Vesp</span>`
          : `<span class="tchip tm">☀️ Mat</span>`;
        return `
        <div class="tcard">
          <div class="tcard-main">
            <div class="tcard-name"><a href="#" class="prof-link" data-prof="${esc(e.profesor)}">${esc(e.profesor)}</a> ${turnoChip}${e.carrera !== CARRERA ? ` <span class="eq-tag" title="Materia equivalente de ${esc(e.carrera)} (${esc(e.clave)}): cuenta como tu ${esc(PLAN[s].materias[i][0])}">Equivalente · ${esc(e.carrera)}</span>` : ""}</div>
            <div class="tcard-grupo">${esc(e.grupo)} · Ed. ${esc(e.edificio)} · Salón ${esc(e.salon)}${rama ? ` · <b>${esc(titleCase(rama))}</b>` : ""} ${cupoBadge(e.grupo, e.materia)}</div>
            <div class="tcard-sesiones">${esc(sesionesText(e.sesiones))}</div>
            ${miniMetrics(m)}
          </div>
          <button class="addBtn ${inH ? "added" : ""}" data-k="${k}">
            ${inH ? "✓ En horario" : "+ Horario"}
          </button>
        </div>`;
      }).join("")}
    </div>`;

  drop.querySelectorAll(".prof-link").forEach((a) => {
    a.onclick = (e) => { e.preventDefault(); showProfDetail(a.dataset.prof); };
  });

  drop.querySelector(".cmpBtn")?.addEventListener("click", () => abrirComparador(s, i));
  drop.querySelector(".eqBtn")?.addEventListener("click", () => { drop.dataset.eq = conEq ? "" : "1"; renderDrop(drop, s, i); });

  drop.querySelectorAll(".addBtn").forEach((btn) => {
    btn.onclick = () => {
      const entry = list[parseInt(btn.dataset.k)];
      const adding = !state.horario.some(
        (h) => h.sid === id && h.maestro === entry.profesor && (h.grupo || "") === entry.grupo
      );

      // Si es optativa y se está agregando, el lugar queda con esa optativa:
      // su nombre (con la rama en ISC) y su clave, que es lo que se guarda
      // en la cuenta.
      if (isOpt && adding) {
        setSub(id, { name: nombreDeSlot(id, entry.materia), clave: entry.clave });
        const nameEl = drop.closest(".subject").querySelector(".name");
        nameEl.innerHTML = esc(getSub(id, "").name) + `<span class="opttag">${OPT_SLOTS[id].label}</span>` + botonMateria(entry.clave);
      }

      toggleHorario(armarItemHorario(entry, s, i), btn);
    };
  });
}

// Nombre de un lugar de optativa ya elegido: "Optativa A1 · Minería De Datos".
// ISC escribe "RAMA|NOMBRE EN INGLÉS" y nos quedamos con la rama; IA y LCD
// no tienen ramas, así que va el nombre de la materia.
function nombreDeSlot(id, materiaSaes) {
  const rama = materiaSaes.includes("|") ? materiaSaes.split("|")[0].trim() : materiaSaes.trim();
  return "Optativa " + OPT_SLOTS[id].label + " · " + titleCase(rama);
}

// Una oferta de SCHEDULE convertida en renglón del horario del alumno.
// También la usa cuenta.js para rearmar el horario guardado en la cuenta.
function armarItemHorario(entry, s, i) {
  const subRec = getSub(idOf(s, i), "");
  return {
    sid: idOf(s, i),
    oferta: entry.id,         // id de la oferta en la base: es lo que guarda la cuenta
    materia: subjectName(s, i),
    matReal: entry.materia,   // materia del schedule (con rama) para cruzar cupos
    maestro: entry.profesor,
    grupo: entry.grupo,
    edificio: entry.edificio,
    salon: entry.salon,
    sesiones: entry.sesiones,
    cred: PLAN[s].materias[i][1],
    tipo: subRec.veces >= 2 || subRec.status === "reprobada" ? "recurse" : "nueva",
  };
}

function miniMetrics(m) {
  return `<div class="tcard-metrics">
    ${metricCell(m.calidad, "cal")}
    ${metricCell(m.recomiendan, "rec")}
    ${metricCell(m.dificultad, "dif")}
  </div>`;
}

// ============================================================
//  HORARIO (estado compartido)
// ============================================================
function toggleHorario(item, btn) {
  const idx = state.horario.findIndex(
    (h) =>
      h.sid === item.sid &&
      h.maestro === item.maestro &&
      (h.grupo || "") === (item.grupo || "")
  );
  if (idx >= 0) {
    if (!confirmarBaja(state.horario[idx])) return;
    state.horario.splice(idx, 1);
    if (btn) { btn.classList.remove("added"); btn.textContent = "+ Horario"; }
  } else {
    // P13: bloquear materia duplicada (mismo sid con otro grupo/profesor)
    const dup = state.horario.find((h) => h.sid === item.sid);
    if (dup) {
      alert(`Ya tienes "${dup.materia}" en tu horario (con ${dup.maestro}, ${dup.grupo}). Solo puedes inscribir una vez la misma materia.`);
      return;
    }
    // Ventana de 3 semestres desde lo más bajo que debes: no se permite salirse.
    const v = ventanaInscripcion();
    const sem = Number(item.sid.match(/^s(\d+)-/)[1]) + 1;
    if (v && sem > v.hi) {
      alert(`No puedes inscribir ${item.materia} (${sem}.º): debes materias de ${v.lo}.º, así que solo puedes inscribir de ${v.lo}.º a ${v.hi}.º semestre.`);
      return;
    }
    if (!cabeEnCarga(item.sid)) return;          // más de la carga máxima no se permite
    state.horario.push(item);
    if (btn) { btn.classList.add("added"); btn.textContent = "✓ En horario"; }
    // Seriación: solo avisa (CLAUDE.md §4.4).
    const falta = prereqsFaltantesDe(item.sid);
    if (falta.length) {
      alert(`Aviso de seriación: ${item.materia} va después de ${falta.map((f) => f.name).join(" y ")}, que no tienes aprobada. Se agregó a tu horario de todos modos.`);
    }
  }
  save();
  // Refrescar el badge de la materia en la pestaña Mi avance (Pendiente ⇄ Inscrita)
  const subj = planEl.querySelector(`.subject[data-id="${item.sid}"]`);
  if (subj) applyRowMode(subj, getSub(item.sid));
}

// ============================================================
//  RENDER PRINCIPAL (avance)
// ============================================================
const ribbon = document.getElementById("ribbon");

function render() {
  const counts = { todas: 0, pendiente: 0, aprobada: 0, reprobada: 0 };
  let creditosOk = 0;
  let sumCalif = 0, nCalif = 0, nAprob = 0, nAprobSinNum = 0;
  ribbon.innerHTML = "";

  PLAN.forEach((blk, s) => {
    const sec = planEl.querySelector(`.sem[data-sem="${s}"]`);
    let semOk = 0;
    blk.materias.forEach(([name, cred], i) => {
      const id = idOf(s, i);
      const rec = getSub(id, name);
      counts[rec.status]++; counts.todas++;
      if (rec.status === "aprobada") { creditosOk += cred; semOk++; nAprob++; }
      // Promedio como el Kárdex: la última calificación de cada materia, aprobada o reprobada.
      const fin = califParaPromedio(rec);
      if (fin !== null) { sumCalif += fin; nCalif++; }
      else if (rec.status === "aprobada") nAprobSinNum++;
    });
    sec.querySelector(".semOk").textContent = semOk;
    sec.querySelector(".semFill").style.width = (semOk / blk.materias.length) * 100 + "%";
  });

  // P10: barra continua. Solo cuenta aprobadas. Color cambia según %.
  const pct = Math.min(100, (creditosOk / TOTAL) * 100);
  const fill = ribbon.querySelector(".ribbon-fill") || (() => {
    ribbon.innerHTML = '<div class="ribbon-fill"></div>';
    return ribbon.querySelector(".ribbon-fill");
  })();
  fill.style.width = pct.toFixed(1) + "%";
  // Paleta progresiva: rojo→naranja→amarillo→verde
  let fillColor;
  if (pct >= 80) fillColor = "#15803d";        // verde fuerte
  else if (pct >= 60) fillColor = "#84cc16";   // verde claro
  else if (pct >= 40) fillColor = "#facc15";   // amarillo
  else if (pct >= 20) fillColor = "#f97316";   // naranja
  else fillColor = "#dc2626";                  // rojo
  fill.style.background = fillColor;

  document.getElementById("creditosOk").textContent = creditosOk % 1 ? creditosOk.toFixed(1) : creditosOk;
  document.getElementById("pctOk").textContent = Math.round((creditosOk / TOTAL) * 100);
  document.getElementById("promedio").textContent = nCalif ? (sumCalif / nCalif).toFixed(2) : "—";
  // De cuántas materias sale, y cuántas aprobadas no tienen número.
  const nota = document.getElementById("promedioNota");
  if (nota) {
    const sinNum = nAprobSinNum ? ` · ${nAprobSinNum} aprobada${nAprobSinNum === 1 ? "" : "s"} sin número no cuenta${nAprobSinNum === 1 ? "" : "n"}` : "";
    nota.textContent = nCalif
      ? `De ${nCalif} materia${nCalif === 1 ? "" : "s"} con calificación, aprobadas y reprobadas, como tu Kárdex${sinNum}`
      : nAprob ? "Tus aprobadas no tienen número" : "";
  }
  if (typeof pintarFechas === "function") pintarFechas();

  Object.keys(counts).forEach((k) => {
    const el = document.querySelector(`.num[data-c="${k}"]`);
    if (el) el.textContent = counts[k];
  });
  document.querySelectorAll(".chip").forEach((c) => {
    c.setAttribute("aria-pressed", c.dataset.k === filter);
  });

  refreshBadges();
  applyFilters();
}

// Re-aplica el estado de cada fila (incluye el badge Pendiente ⇄ Inscrita)
function refreshBadges() {
  planEl.querySelectorAll(".subject").forEach((subj) => {
    const id = subj.dataset.id;
    const m = id && id.match(/^s(\d+)-(\d+)$/);
    if (!m) return;
    const name = PLAN[+m[1]].materias[+m[2]][0];
    applyRowMode(subj, getSub(id, name));
  });
}

// ---- Filtros ----
const searchEl = document.getElementById("search");
function applyFilters() {
  const q = searchEl.value.trim().toLowerCase();
  planEl.querySelectorAll(".sem").forEach((sec) => {
    let visible = 0;
    sec.querySelectorAll(".subject").forEach((subj) => {
      const badge = subj.querySelector(".status-badge");
      const st = badge ? badge.dataset.st : "pendiente";
      const nm = subj.querySelector(".name").textContent.toLowerCase();
      const okFilter = filter === "todas" || st === filter;
      const okSearch = !q || nm.includes(q);
      const show = okFilter && okSearch;
      subj.classList.toggle("hidden", !show);
      if (show) visible++;
    });
    sec.classList.toggle("hidden", visible === 0);
  });
}
searchEl.addEventListener("input", applyFilters);

