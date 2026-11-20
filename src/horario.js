// ============================================================
//  PESTAÑA 3 · GENERAR HORARIO
// ============================================================
const horarioListEl = document.getElementById("horarioList");
const credSummaryEl = document.getElementById("credSummary");

// ---------- carga académica en UA (CLAUDE.md §4.1) ----------
// Lo que inscribes + lo que ya solo puede ir por ETS (cuenta aunque no esté
// en el horario). TT I y TT II valen 2 UA; las demás, 1.
function cargaActual() {
  const enHorario = state.horario.reduce((a, h) => a + uaDe(h.sid), 0);
  const soloEts = uaBloqueadas();
  return { enHorario, soloEts, total: enHorario + soloEts };
}

function semDeId(id) { return Number(id.match(/^s(\d+)-/)[1]) + 1; }

// Avisos del horario. Solo avisan, nunca bloquean (salvo pasar de la máxima,
// que ni se deja agregar).
function avisosDelHorario() {
  const av = [];
  const c = cargaActual();
  if (c.total > CARGA.max) {
    av.push(`Llevas ${c.total} UA y el máximo es ${CARGA.max}. Quita ${c.total - CARGA.max}.`);
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
  return av;
}

// ¿Cabe una materia más? Pasar de la carga máxima no se permite.
function cabeEnCarga(sid) {
  const despues = cargaActual().total + uaDe(sid);
  if (despues <= CARGA.max) return true;
  alert(`No cabe: llevarías ${despues} UA y la carga máxima es ${CARGA.max}.`);
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
  const inscritos = state.horario.reduce((a, h) => a + h.cred, 0);
  const nMaterias = state.horario.length;
  const nivel = carga.total > CARGA.max ? "danger" : carga.total > CARGA.media ? "warn" : "";

  // P12: promedios de calidad y dificultad (simples, sin ponderar)
  let sumCal = 0, sumDif = 0, nCal = 0, nDif = 0;
  state.horario.forEach((h) => {
    const m = getMetric(h.maestro);
    if (m.calidad !== "" && m.calidad != null) { sumCal += Number(m.calidad); nCal++; }
    if (m.dificultad !== "" && m.dificultad != null) { sumDif += Number(m.dificultad); nDif++; }
  });
  const promCal = nCal ? (sumCal / nCal) : null;
  const promDif = nDif ? (sumDif / nDif) : null;

  credSummaryEl.innerHTML = `
    <div class="cs-card ${nivel}">
      <div class="cs-val">${carga.total} <span class="cs-max">/ ${CARGA.media} UA</span></div>
      <div class="cs-label">Carga (media ${CARGA.media}, máx. ${CARGA.max})${carga.soloEts ? ` <span class="cs-bloq">(${carga.soloEts} solo por ETS)</span>` : ""}</div>
    </div>
    <div class="cs-card">
      <div class="cs-val">${nMaterias}</div>
      <div class="cs-label">Materias inscritas · ${fmt(inscritos)} cr</div>
    </div>
    <div class="cs-card">
      <div class="cs-val ${promCal != null ? "color-" + metricColor(promCal.toFixed(1), "cal") : ""}">${promCal != null ? promCal.toFixed(1) : "—"}</div>
      <div class="cs-label">Calidad promedio</div>
    </div>
    <div class="cs-card">
      <div class="cs-val ${promDif != null ? "color-" + metricColor(promDif.toFixed(1), "dif") : ""}">${promDif != null ? promDif.toFixed(1) : "—"}</div>
      <div class="cs-label">Dificultad promedio</div>
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

  if (state.horario.length === 0) {
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
    return `
    <div class="hcard ${hasConflict ? "conflict" : ""}">
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
      </div>
      <button class="hdel" data-idx="${idx}" title="Quitar del horario">✕</button>
    </div>`;
  }).join("");

  horarioListEl.querySelectorAll(".prof-link").forEach((a) => {
    a.onclick = (e) => { e.preventDefault(); showProfDetail(a.dataset.prof); };
  });

  horarioListEl.querySelectorAll(".hdel").forEach((btn) => {
    btn.onclick = () => {
      if (!confirmarBaja(state.horario[parseInt(btn.dataset.idx)])) return;
      state.horario.splice(parseInt(btn.dataset.idx), 1);
      save();
      renderHorario();
      // refrescar botones del plan si el drop está abierto
      planEl.querySelectorAll(".drop.open").forEach((d) => {
        const subj = d.closest(".subject");
        const [, s, i] = subj.dataset.id.match(/^s(\d+)-(\d+)$/).map(Number);
        renderDrop(d, s, i);
      });
    };
  });
}

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
            return `<div class="sched-cell" style="background:${c.bg};color:${c.fg};border-color:${c.bd}" title="${esc(h.materia)} · ${esc(h.maestro)}">
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

