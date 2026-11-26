// ============================================================
//  PESTAÑA 3 · GENERAR HORARIO
// ============================================================
const horarioListEl = document.getElementById("horarioList");
const credSummaryEl = document.getElementById("credSummary");

// ---------- carga académica en UA (CLAUDE.md §4.1) ----------
// Lo que inscribes + las reprobadas que no están en el horario (cuentan aunque no estén
// en el horario) + los proyectos que marcaste (TT I, TT II, Estancia: no llevan
// clase, pero ocupan carga). TT I y TT II valen 2 UA; las demás, 1.
function cargaActual() {
  const enHorario = state.horario.reduce((a, h) => a + uaDe(h.sid), 0);
  const soloEts = uaBloqueadas();
  const proyectos = uaProyectos();
  return { enHorario, soloEts, proyectos, total: enHorario + soloEts + proyectos };
}

function semDeId(id) { return Number(id.match(/^s(\d+)-/)[1]) + 1; }

// Avisos del horario. Solo avisan, nunca bloquean (salvo pasar de la máxima,
// que ni se deja agregar).
function avisosDelHorario() {
  const av = [];
  const c = cargaActual();
  const max = cargaMaxPermitida();
  if (c.total > max) {
    av.push(max < CARGA.max
      ? `Llevas ${c.total} UA. Como debes materias (irregular), tu máximo es la carga media: ${max}. Quita ${c.total - max}. Solo los regulares llegan a ${CARGA.max}.`
      : `Llevas ${c.total} UA y el máximo es ${max}. Quita ${c.total - max}.`);
  } else if (c.total > CARGA.media) {
    av.push(`Llevas ${c.total} UA, arriba de la carga media (${CARGA.media}). Inscribir más de la media requiere un trámite ante la Unidad Académica.`);
  } else if (state.horario.length && c.total < CARGA.min) {
    av.push(`Llevas ${c.total} UA, abajo de la carga mínima (${CARGA.min}).`);
  }

  // Seriación: solo avisa (CLAUDE.md §4.4).
  state.horario.forEach((h) => {
    const falta = prereqsFaltantesDe(h.sid);
    if (falta.length) {
      av.push(`Seriación: ${h.materia} va después de ${falta.map((f) => f.name).join(" y ")}, que no tienes aprobada.`);
    }
  });

  // Art. 98: materias de a lo más 3 semestres consecutivos, y no adeudar
  // materias de más de 2 semestres antes del más alto que inscribes.
  if (state.horario.length) {
    const sems = state.horario.map((h) => semDeId(h.sid));
    const lo = Math.min(...sems), hi = Math.max(...sems);
    if (hi - lo >= 3) {
      av.push(`Art. 98: tu horario va de ${lo}.º a ${hi}.º semestre; solo se permiten materias de hasta 3 semestres consecutivos.`);
    }
    const viejas = [];
    PLAN.forEach((blk, s) => blk.materias.forEach(([name], i) => {
      const rec = getSub(idOf(s, i), name);
      if (rec.status === "reprobada" && s + 1 < hi - 2) viejas.push(`${rec.name} (${s + 1}.º)`);
    }));
    if (viejas.length) {
      av.push(`Art. 98: adeudas ${viejas.join(", ")}, de más de 2 semestres antes del ${hi}.º que inscribes.`);
    }
  }

  // ISC: la optativa de 7.º debe ser de la misma rama (trayectoria) que una de
  // las de 6.º; el procedimiento da de baja las de fuera. Solo avisa (usuario, 2026-11-21).
  const fuera = optativasFueraDeTrayectoria();
  if (fuera.length) {
    av.push(`Trayectoria: ${fuera.map((f) => `${f.nombre} (7.º, rama ${f.rama})`).join(", ")} no ${fuera.length === 1 ? "es" : "son"} de la rama de tus optativas de 6.º (${fuera[0].ramas6.join(", ")}). El procedimiento da de baja las optativas fuera de tu trayectoria.`);
  }

  // Desfase y dictamen (docs/reglas-escolares.md).
  const carta = [], dictamen = [];
  PLAN.forEach((blk, s) => blk.materias.forEach(([name], i) => {
    const rec = getSub(idOf(s, i), name);
    if (rec.desfase === "carta24") carta.push(rec.name);
    if (rec.desfase === "dictamen") dictamen.push(rec.name);
  }));
  if (dictamen.length && state.horario.length) {
    av.push(`Dictamen: ${dictamen.join(", ")} lleva${dictamen.length === 1 ? "" : "n"} 4 semestres sin pasar. Solo tienes derecho a ETS y no puedes inscribir nada hasta pasarlo.`);
  } else if (carta.length) {
    av.push(`Desfase: ${carta.join(", ")}. Te reinscribes con carta de 24 créditos y te comprometes a pasarla${carta.length === 1 ? "" : "s"} por ETS.`);
    const cred = state.horario.reduce((a, h) => a + (h.cred || 0), 0);
    if (cred > 24) av.push(`Con carta de 24 créditos tu horario no puede pasar de 24; lleva ${cred % 1 ? cred.toFixed(1) : cred}.`);
  }
  return av;
}

// Optativas de 7.º cuya rama no es la de ninguna de tus optativas de 6.º (solo
// ISC, que es la que tiene trayectorias; datos de api/optativas.php).
function optativasFueraDeTrayectoria() {
  if (CARRERA !== "ISC" || typeof ESPECIALIZACIONES === "undefined" || !ESPECIALIZACIONES.length) return [];
  const ramaDe = {};
  ESPECIALIZACIONES.forEach((r) => r.materias.forEach((m) => { ramaDe[m.clave] = r.nombre; }));
  const elegidas = (sem) => Object.entries(OPT_SLOTS)
    .filter(([id, sl]) => sl.sem === sem && state.subjects[id] && state.subjects[id].clave)
    .map(([id]) => ({ clave: state.subjects[id].clave, nombre: getSub(id, "").name }));
  const ramas6 = [...new Set(elegidas(6).map((o) => ramaDe[o.clave]).filter(Boolean))];
  if (!ramas6.length) return [];
  return elegidas(7)
    .filter((o) => ramaDe[o.clave] && !ramas6.includes(ramaDe[o.clave]))
    .map((o) => ({ nombre: o.nombre, rama: ramaDe[o.clave], ramas6 }));
}

// ¿Cabe una materia más? Pasar de la carga máxima no se permite; si eres
// irregular, tu máxima es la media (cargaMaxPermitida, core.js).
function cabeEnCarga(sid) {
  const despues = cargaActual().total + uaDe(sid);
  const max = cargaMaxPermitida();
  if (despues <= max) return true;
  alert(max < CARGA.max
    ? `No cabe: llevarías ${despues} UA. Como debes materias (irregular), tu máximo es la carga media: ${max} UA. Solo los regulares pueden llegar a ${CARGA.max}.`
    : `No cabe: llevarías ${despues} UA y la carga máxima es ${max}.`);
  return false;
}

// Quitar del horario algo cuya baja no procede: avisa y deja decidir.
function confirmarBaja(item) {
  const motivos = [];
  if (item.tipo === "recurse") motivos.push("la estás recursando, y la baja de un recurse no procede");
  const quedan = cargaActual().total - uaDe(item.sid);
  if (quedan > 0 && quedan < CARGA.min) motivos.push(`quedarías con ${quedan} UA, abajo de la carga mínima (${CARGA.min})`);
  if (!motivos.length) return true;
  return confirm(`Ojo con ${item.materia}: ${motivos.join("; y ")}.\n\n¿Quitarla de tu horario de todos modos?`);
}

function renderHorario() {
  const carga = cargaActual();
  // Los proyectos (TT I, TT II, Estancia) no están en state.horario: no tienen
  // oferta ni hora. Se listan aparte, pero cuentan en la carga y en créditos.
  const proyectos = proyectosEnCurso();
  const inscritos = state.horario.reduce((a, h) => a + h.cred, 0) + proyectos.reduce((a, p) => a + p.cred, 0);
  const nMaterias = state.horario.length + proyectos.length;
  const maxPermitida = cargaMaxPermitida();
  const nivel = carga.total > maxPermitida ? "danger" : carga.total > CARGA.media ? "warn" : "";

  // P12: promedios de calidad y dificultad (simples, sin ponderar)
  let sumCal = 0, sumDif = 0, nCal = 0, nDif = 0;
  state.horario.forEach((h) => {
    const m = getMetric(h.maestro);
    if (m.calidad !== "" && m.calidad != null) { sumCal += Number(m.calidad); nCal++; }
    if (m.dificultad !== "" && m.dificultad != null) { sumDif += Number(m.dificultad); nDif++; }
  });
  const promCal = nCal ? (sumCal / nCal) : null;
  const promDif = nDif ? (sumDif / nDif) : null;

  // Una sola franja (antes eran 4 tarjetas grandes).
  const prom = (v, kind) => v == null ? "—" : `<b class="cs-val color-${metricColor(v.toFixed(1), kind)}">${v.toFixed(1)}</b>`;
  credSummaryEl.innerHTML = `
    <div class="cs-strip ${nivel}">
      <span title="Carga media ${CARGA.media} UA, máxima ${maxPermitida}${maxPermitida < CARGA.max ? " (eres irregular: solo los regulares llegan a " + CARGA.max + ")" : ""}"><b>${carga.total}</b>/${CARGA.media} UA
        <small>(máx. ${maxPermitida})</small>${carga.soloEts ? ` <span class="cs-bloq" title="Las reprobadas ocupan carga hasta que las apruebes, aunque no estén en tu horario">${carga.soloEts} de reprobadas</span>` : ""}${carga.proyectos ? ` <span class="cs-bloq" title="Trabajo terminal y Estancia no llevan clase, pero sí ocupan carga">${carga.proyectos} de proyectos</span>` : ""}</span>
      <span><b>${nMaterias}</b> materia${nMaterias === 1 ? "" : "s"} · ${fmt(inscritos)} cr</span>
      <span title="Promedio de MisProfesores de tus maestros">Calidad ${prom(promCal, "cal")}</span>
      <span title="Promedio de MisProfesores de tus maestros (bajo = más fácil)">Dificultad ${prom(promDif, "dif")}</span>
    </div>`;

  const avisos = avisosDelHorario();
  if (avisos.length) {
    const box = document.createElement("div");
    box.className = "over-warn avisos";
    box.innerHTML = `<b>⚠️ Avisos</b><ul>${avisos.map((a) => `<li>${esc(a)}</li>`).join("")}</ul>`;
    credSummaryEl.appendChild(box);
  }

  // Rejilla semanal
  document.getElementById("horarioTable").innerHTML = renderHorarioTable();

  if (state.horario.length === 0 && proyectos.length === 0) {
    horarioListEl.innerHTML = `<div class="drop-empty big">Tu horario está vacío.<br>Ve a <b>Mi avance</b>, abre <b>Maestros</b> en una materia pendiente o reprobada y pulsa <b>+ Horario</b>.</div>`;
    return;
  }

  // ¿Quiénes chocan con quién?
  const conflictWith = state.horario.map(() => new Set());
  for (let a = 0; a < state.horario.length; a++) {
    for (let b = a + 1; b < state.horario.length; b++) {
      if (itemsConflict(state.horario[a], state.horario[b])) {
        conflictWith[a].add(b);
        conflictWith[b].add(a);
      }
    }
  }
  const totalConflicts = conflictWith.reduce((n, s) => n + s.size, 0) / 2;
  if (totalConflicts > 0) {
    const warn = document.createElement("div");
    warn.className = "over-warn";
    warn.textContent = `⚠️ Hay ${totalConflicts} choque${totalConflicts === 1 ? "" : "s"} de horario. Las materias en rojo coinciden en el mismo día y hora.`;
    credSummaryEl.appendChild(warn);
  }

  horarioListEl.innerHTML = state.horario.map((h, idx) => {
    const m = getMetric(h.maestro);
    const hasConflict = conflictWith[idx].size > 0;
    const aula = h.edificio ? `Ed. ${esc(h.edificio)} · Salón ${esc(h.salon)}` : "";
    const mantenida = !h._auto;
    return `
    <div class="hcard ${hasConflict ? "conflict" : ""}" id="hcard-${idx}">
      <div class="hcard-info">
        <div class="hcard-top">
          <span class="hcard-mat">${esc(h.materia)}</span>
          <span class="tipo-tag ${h.tipo}">${h.tipo === "recurse" ? "Recursamiento" : "Nueva"}</span>
          <span class="hcard-cred">${fmt(h.cred)} cr</span>
          ${hasConflict ? `<span class="conflict-tag">⚠ Choque</span>` : ""}
        </div>
        <div class="hcard-prof"><a href="#" class="prof-link" data-prof="${esc(h.maestro)}">${esc(h.maestro)}</a> · <span class="hcard-grupo">${esc(h.grupo || "")}${aula ? " · " + aula : ""}</span></div>
        ${h.sesiones && h.sesiones.length ? `<div class="hcard-ses">${esc(sesionesText(h.sesiones))}</div>` : ""}
        ${miniMetrics(m)}
        <div class="hcard-alts" id="halts-${idx}"></div>
      </div>
      <div class="hcard-acc">
        <button class="hacc" data-hacc="cambiar" data-idx="${idx}" title="Ver otros grupos y maestros de esta materia">🔄 Cambiar</button>
        <button class="hacc${mantenida ? " on" : ""}" data-hacc="mantener" data-idx="${idx}" aria-pressed="${mantenida}"
          title="${mantenida ? "El automático no la toca. Pulsa para que 🎲 Otra la pueda cambiar." : "🎲 Otra la puede cambiar. Pulsa para conservarla."}">📌 ${mantenida ? "Se queda" : "Mantener"}</button>
        <button class="hacc peligro" data-hacc="quitar" data-idx="${idx}" title="Quitar del horario">✕ Quitar</button>
      </div>
    </div>`;
  }).join("") + proyectos.map((p) => `
    <div class="hcard proyecto">
      <div class="hcard-info">
        <div class="hcard-top">
          <span class="hcard-mat">${esc(p.name)}</span>
          <span class="tipo-tag proyecto">Proyecto</span>
          <span class="hcard-cred">${fmt(p.cred)} cr</span>
        </div>
        <div class="hcard-prof">No lleva clase: no tiene grupo, maestro ni horario, solo calificación.
          Ocupa ${p.ua} UA de tu carga mientras lo llevas.</div>
      </div>
      <div class="hcard-acc">
        <button class="hacc peligro" data-hacc="quitar-proyecto" data-pid="${p.id}"
          title="Ya no lo estoy llevando">✕ Quitar</button>
      </div>
    </div>`).join("");

  horarioListEl.querySelectorAll(".prof-link").forEach((a) => {
    a.onclick = (e) => { e.preventDefault(); showProfDetail(a.dataset.prof); };
  });
}

// ============================================================
//  Acciones de cada materia del horario: Cambiar · Mantener · Quitar
// ============================================================
// Las usan las tarjetas de la lista y el menú que sale al tocar una materia
// en la rejilla. Cualquier cambio a mano invalida las combinaciones que ya
// tenía barajadas el automático (🎲 Otra vuelve a calcular).

function trasCambioManual() {
  if (typeof autoPool !== "undefined") { autoPool = []; autoLastKey = null; }
  save();
  renderHorario();
  // refrescar los botones del plan si hay un "Maestros" abierto
  planEl.querySelectorAll(".drop.open").forEach((d) => {
    const subj = d.closest(".subject");
    const [, s, i] = subj.dataset.id.match(/^s(\d+)-(\d+)$/).map(Number);
    renderDrop(d, s, i);
  });
}

function quitarDelHorario(idx) {
  if (!confirmarBaja(state.horario[idx])) return;
  state.horario.splice(idx, 1);
  trasCambioManual();
}

// 📌 Mantener: el automático conserva todo lo que no trae _auto.
function alternarMantener(idx) {
  const h = state.horario[idx];
  if (h._auto) delete h._auto; else h._auto = true;
  trasCambioManual();
}

// Las otras ofertas de la MISMA materia (otro grupo u otro maestro), con
// si chocan con el resto de tu horario. Orden: las que no chocan, las de tu
// mismo turno, y luego por calidad del maestro.
function alternativasDe(idx) {
  const h = state.horario[idx];
  const [, s, i] = h.sid.match(/^s(\d+)-(\d+)$/).map(Number);
  const otras = state.horario.filter((_, k) => k !== idx);
  const mat = norm(h.matReal || h.materia);
  const turno = turnoDeGrupo(h.grupo);
  return scheduleFor(s, i, false)   // sin equivalentes de otras carreras
    .filter((e) => norm(e.materia) === mat && !(e.grupo === h.grupo && norm(e.profesor) === norm(h.maestro)))
    .map((e) => {
      const item = armarItemHorario(e, s, i);
      const cal = Number(getMetric(e.profesor).calidad);
      return { e, item, choca: otras.some((o) => itemsConflict(item, o)), otroTurno: turnoDeGrupo(e.grupo) !== turno,
               cal: Number.isFinite(cal) ? cal : -1 };
    })
    .sort((a, b) => (a.choca - b.choca) || (a.otroTurno - b.otroTurno) || (b.cal - a.cal) || a.e.grupo.localeCompare(b.e.grupo));
}

function abrirCambiar(idx) {
  const caja = document.getElementById("halts-" + idx);
  if (!caja) return;
  if (caja.innerHTML) { caja.innerHTML = ""; return; }      // segundo clic: cerrar
  const alts = alternativasDe(idx);
  caja.innerHTML = !alts.length
    ? `<div class="drop-empty">No hay otro grupo ni otro maestro de esta materia este periodo.</div>`
    : `<div class="halts-tit">Otros grupos de esta materia (${alts.length})</div>` + alts.map((a, k) => {
        const m = getMetric(a.e.profesor);
        return `<div class="halt${a.choca ? " choca" : ""}">
          <div class="halt-info">
            <b>${esc(a.e.grupo)}</b> · ${esc(a.e.profesor || "Sin profesor")} ${metricCell(m.calidad, "cal")}
            ${cupoBadge(a.e.grupo, a.e.materia)}
            ${a.choca ? `<span class="conflict-tag">Choca</span>` : ""}
            <div class="halt-ses">${esc(sesionesText(a.e.sesiones || []))}</div>
          </div>
          <button class="btn" data-hacc="elegir" data-idx="${idx}" data-alt="${k}">Elegir</button>
        </div>`;
      }).join("");
  caja._alts = alts;
  caja.scrollIntoView({ behavior: "smooth", block: "nearest" });
}

function elegirAlternativa(idx, k) {
  const caja = document.getElementById("halts-" + idx);
  const alt = caja && caja._alts && caja._alts[k];
  if (!alt) return;
  if (alt.choca && !confirm("Ese grupo choca con otra materia de tu horario. ¿Cambiarlo de todos modos?")) return;
  state.horario[idx] = alt.item;          // sin _auto: lo elegiste tú, se queda
  trasCambioManual();
}

horarioListEl.addEventListener("click", (e) => {
  const b = e.target.closest("[data-hacc]");
  if (!b) return;
  const idx = Number(b.dataset.idx);
  ({
    cambiar: () => abrirCambiar(idx),
    mantener: () => alternarMantener(idx),
    quitar: () => quitarDelHorario(idx),
    elegir: () => elegirAlternativa(idx, Number(b.dataset.alt)),
    // Un proyecto no se "quita del horario": se desmarca en el avance.
    "quitar-proyecto": () => { setSub(b.dataset.pid, { proy: false }); trasCambioManual(); render(); },
  })[b.dataset.hacc]?.();
});

// ---------- menú corto al tocar una materia en la rejilla ----------
const hmenuEl = document.createElement("div");
hmenuEl.className = "hmenu";
hmenuEl.hidden = true;
document.body.appendChild(hmenuEl);

function cerrarHmenu() { hmenuEl.hidden = true; }

document.getElementById("horarioTable").addEventListener("click", (e) => {
  const cell = e.target.closest(".sched-cell[data-idx]");
  if (!cell) return;
  e.stopPropagation();
  const idx = Number(cell.dataset.idx);
  const h = state.horario[idx];
  hmenuEl.innerHTML = `
    <div class="hmenu-tit">${esc(h.materia)}<small>${esc(h.grupo || "")} · ${esc(h.maestro || "")}</small></div>
    <button data-hm="cambiar">🔄 Cambiar grupo o maestro</button>
    <button data-hm="mantener">📌 ${h._auto ? "Mantener" : "Dejar que el automático la cambie"}</button>
    <button data-hm="quitar" class="peligro">✕ Quitar del horario</button>`;
  hmenuEl.dataset.idx = idx;
  hmenuEl.hidden = false;
  const r = cell.getBoundingClientRect();
  const ancho = hmenuEl.offsetWidth;
  hmenuEl.style.left = Math.max(8, Math.min(r.left + window.scrollX, window.scrollX + document.documentElement.clientWidth - ancho - 8)) + "px";
  hmenuEl.style.top = (r.bottom + window.scrollY + 4) + "px";
});

hmenuEl.addEventListener("click", (e) => {
  const b = e.target.closest("[data-hm]");
  if (!b) return;
  const idx = Number(hmenuEl.dataset.idx);
  cerrarHmenu();
  if (b.dataset.hm === "cambiar") {
    document.getElementById("hcard-" + idx)?.classList.add("resaltado");
    abrirCambiar(idx);
  }
  if (b.dataset.hm === "mantener") alternarMantener(idx);
  if (b.dataset.hm === "quitar") quitarDelHorario(idx);
});
document.addEventListener("click", (e) => { if (!hmenuEl.hidden && !hmenuEl.contains(e.target)) cerrarHmenu(); });
document.addEventListener("keydown", (e) => { if (e.key === "Escape") cerrarHmenu(); });
// El menú va en coordenadas de la página: se mueve con ella al desplazarte.

function fmt(n) { return n % 1 ? n.toFixed(1) : String(n); }

// Acorta el nombre de la materia para la celda de la rejilla
function shortMat(s) {
  return s.replace(/^Optativa /i, "Opt. ");
}

// Genera la rejilla semanal del horario
function renderHorarioTable() {
  if (state.horario.length === 0) return "";

  // Mapear materias a color (estable por sid)
  const colorOf = new Map();
  state.horario.forEach((h) => {
    if (!colorOf.has(h.sid)) {
      colorOf.set(h.sid, SCHED_COLORS[colorOf.size % SCHED_COLORS.length]);
    }
  });

  // Bloques ocupados
  const blockIdx = (ini) => TIME_BLOCKS.findIndex((b) => b.ini === ini);
  const occupied = new Set();
  state.horario.forEach((h) =>
    (h.sesiones || []).forEach((s) => {
      const k = blockIdx(s.ini);
      if (k >= 0) occupied.add(k);
    })
  );
  if (occupied.size === 0) return "";

  const minIdx = Math.min(...occupied);
  const maxIdx = Math.max(...occupied);

  let html = `<table class="sched-table"><thead><tr>
    <th class="sched-hora">Hora</th>
    ${(typeof calSemanaActual === "function" ? calSemanaActual() : DIAS.map((d) => ({ dia: d })))
      .map((x) => {
        const cls = [x.inhabil ? "ghd-inhabil" : "", x.hoy ? "ghd-hoy" : ""].filter(Boolean).join(" ");
        const sub = x.fecha
          ? `<span class="ghd-fecha">${x.inhabil ? esc(x.inhabil) : calCorta(x.fecha)}</span>`
          : "";
        return `<th${cls ? ` class="${cls}"` : ""}${x.inhabil ? ` title="${esc(x.inhabil)}"` : ""}>${x.dia}${sub}</th>`;
      }).join("")}
  </tr></thead><tbody>`;

  for (let i = minIdx; i <= maxIdx; i++) {
    const b = TIME_BLOCKS[i];
    html += `<tr><th class="sched-hora">${b.ini}<br>${b.fin}</th>`;
    DIAS.forEach((d) => {
      const items = state.horario.filter((h) =>
        (h.sesiones || []).some((s) => s.dia === d && s.ini === b.ini)
      );
      const conflict = items.length > 1;
      if (items.length === 0) {
        html += `<td class="sched-empty"></td>`;
      } else {
        const inner = items
          .map((h) => {
            const c = colorOf.get(h.sid);
            // data-idx: al tocarla sale el menú Cambiar / Mantener / Quitar
            return `<div class="sched-cell" data-idx="${state.horario.indexOf(h)}" style="background:${c.bg};color:${c.fg};border-color:${c.bd}" title="${esc(h.materia)} · ${esc(h.maestro)} — toca para cambiar o quitar">
              <div class="sched-mat">${esc(shortMat(h.materia))}</div>
              <div class="sched-meta">${esc(h.grupo || "")}${h.salon ? " · S." + esc(h.salon) : ""}</div>
              ${cupoBadge(h.grupo, h.matReal || h.materia)}
            </div>`;
          })
          .join("");
        html += `<td class="${conflict ? "sched-conflict" : ""}">${inner}</td>`;
      }
    });
    html += `</tr>`;
    // Receso matutino después del bloque 08:30–10:00
    if (b.ini === "08:30" && maxIdx > i) {
      html += `<tr class="sched-receso"><td colspan="${DIAS.length + 1}">☕ Receso 10:00 – 10:30</td></tr>`;
    }
    // Receso vespertino después del bloque 16:30–18:00
    if (b.ini === "16:30" && maxIdx > i) {
      html += `<tr class="sched-receso"><td colspan="${DIAS.length + 1}">☕ Receso 18:00 – 18:30</td></tr>`;
    }
  }

  html += `</tbody></table>`;
  return html;
}

