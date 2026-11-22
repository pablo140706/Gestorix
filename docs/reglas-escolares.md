# Reglas escolares que usa Gestorix (desfase, dictamen y sobrecupo)

Lo que la app toma como regla para avisar. El usuario pidió (2026-11-21) que se muestren **como
regla oficial**. Fuente: lo que cuentan alumnos de ESCOM en grupos de Facebook y la página
"Estado General" de SAES; no viene del texto del Reglamento General de Estudios. Si ESCOM publica
otra cosa, manda ESCOM. **Solo avisan, nunca bloquean** (como la seriación y el Art. 98).

## Formas de acreditar una materia

Por **curso** (1.ª vez), **recurse** (2.ª vez), **ETS** o **ETS especial**. Si la diste de **baja**,
no cuenta como curso: vuelve a ser 1.ª vez.

## Desfase, carta de 24 créditos y dictamen

Corregido por el usuario (2026-11-21). **Se cuenta desde el periodo en que reprobaste el
ordinario** (la 1.ª vez), aunque después la recursaras. Si repruebas el recurse, ya no tienes
derecho a recursar: solo ETS.

| Periodo (P = reprobaste el ordinario) | Situación | En la app |
|---|---|---|
| P+1 | A tiempo: recursa o presenta ETS | — |
| P+2 (tu 3.er semestre) | **Último**: tienes que pasarla ahí (por ETS si ya reprobaste el recurse) | ⏳ aviso amarillo |
| P+3 | **Desfasada**: te reinscribes con **carta de 24 créditos** (menos materias) y te comprometes a pasarla por ETS | ⚠️ "Desfasada · carta 24 cr" |
| P+4 o más (4 semestres sin pasarla) | **Dictamen**: solo tienes derecho a ETS y **no puedes inscribir nada** hasta pasarlo | ⛔ "Dictamen · solo ETS" |

Cada caso es distinto en Gestión Escolar, así que la app **avisa y no bloquea** en estos casos. El
periodo se pregunta en la ventana de "Reprobaste…" ("¿en qué periodo reprobaste el ordinario?") o
sale del Estado General de SAES (su periodo es el del ordinario). Del Kárdex, que solo muestra el
recurse, se toma el periodo anterior al recurse.

La ventana de 3 semestres (abajo) existe justo para mantenerte sin trámites: sin carta de 24
créditos ni dictamen.

## Ventana de 3 semestres y carga

- Solo inscribes materias desde el semestre más bajo que debes hasta dos más (debes de 1.º → 1.º a
  3.º). **La app no deja salirse.**
- **Solo los regulares** (no deben nada de semestres anteriores) pueden meter la carga máxima; los
  irregulares, hasta la media.
- **Todas las reprobadas ocupan carga** hasta que las apruebes, aunque no estén en tu horario.
- **Grupos de recurse**, solo en 1.er semestre: mañana del 7 en adelante (1CM1–1CM6 regulares) y
  tarde del 6 en adelante (1CV1–1CV5 regulares). El automático mete primero las reprobadas que aún
  se pueden recursar; en 1.º, solo en grupos de recurse.
- **Optativas de ISC fuera de trayectoria**: la app avisa (el procedimiento las da de baja).

## Cupo y sobrecupo

Cada grupo abre **36 lugares** por etapas:

| Etapa | Lugares | Para quién |
|---|---|---|
| 1 | 30 | Regulares, los primeros días |
| 2 | +4 | Irregulares **sin** desfase (adeudan materias) |
| 3 | +2 | Con desfase por primera vez, dictamen vigente, recuperados de ETS, regreso de baja |

Mientras no se llenen los 36, es cupo normal. Ya lleno, el **sobrecupo** da de **2 a 4 lugares
más**, **en persona** (al regresar a clases, en la oficina de Gestión Escolar, llegando temprano),
con permiso del **profesor** y de la **subdirección académica**.

## Estado General de SAES

SAES → Datos académicos → **Estado General** muestra tres listas, que la app sabe importar:

| Lista | Columnas | Qué hace la app |
|---|---|---|
| Materias reprobadas | semestre, clave, nombre, periodo (`20261` = 26/1), veces cursada | Reprobada sin número, con sus veces y el periodo |
| Materias no cursadas | semestre, clave, nombre | Se quedan pendientes |
| Materias desfasadas | igual | Reprobada y desfasada |

Lo demás de los semestres que cubren esas listas se propone como **aprobada sin número** (se puede
quitar la palomita a cada una antes de aplicar, por ejemplo si la estás cursando). El HTML se lee
**en tu navegador**: no se manda a ningún lado; a tu cuenta solo sube el avance que resulta.

## Kárdex de SAES

SAES → Datos académicos → **Kárdex** (`kardex.aspx`) trae las **calificaciones** de lo que ya
acreditaste. El mismo botón "Importar de SAES" lo reconoce: busca en cada tabla la fila de títulos
("Clave", "Materia", "Periodo", "Forma de evaluación", "Calificación") y, si no la hay, se guía por la
forma de los datos (clave `C101`, número de 0 a 10).

- Cada calificación queda **con número** y entra al promedio; reemplaza lo capturado en esa materia.
- Si la forma de evaluación dice **ETS** (o título de suficiencia), queda **aprobada por ETS**.
- Si dice **recurse**, queda como 2.ª vez.
- Las **optativas** se acomodan solas en su lugar de optativa de su semestre.
- Si una materia sale dos veces, se queda la aprobatoria.

Probado con un Kárdex real (2026-11-21): tablas por semestre con "Clave, Materia, Fecha, Periodo,
Forma Eval., Calificacion"; la forma `REC` es el recurse.
