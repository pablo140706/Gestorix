# ROADMAP — Gestorix

> Actualizado 2026-11-08. Reglas y decisiones en `CLAUDE.md`. Este archivo es el **orden de trabajo**.
> **Entrega: semana del 30 de noviembre al 4 de diciembre de 2026, funcionando en un sitio web.**
> Meta interna: todo listo el 28 de noviembre, para tener una semana de margen.

---

## Fases

| # | Fase | Fechas | Listo cuando… |
|---|---|---|---|
| 0 | Arranque | 9–10 nov | Repo `gestorix` creado con la versión de iscweb de la PC, Student Pack pedido, servicio de correo elegido, esquema cerrado |
| 1 | Base de datos y datos | 10–14 nov | `docker compose up` levanta Postgres 17, Apache + PHP y pgAdmin; el importador carga las 3 carreras desde el HTML de SAES; cuadran 665 ofertas y 276 maestros |
| 2 | API y front leyendo de la base | 15–19 nov | Las pestañas actuales de iscweb funcionan con datos de `src/api/*.php`, sin `schedule.js` ni los demás `.js` de datos |
| 3 | Cuentas, avance y horario | 19–22 nov | Registro con verificación de correo, alias, avance (con recurse y ETS) y horario guardados; carga en UA (aviso arriba de la media, tope en 9); avisos de seriación y desfase |
| 4 | Profesores y comentarios | 23–25 nov | Ficha única del profesor (MisProfesores + link, comentarios por materia, horario, cédula), comentarios con rúbrica, edición en 24 h, reportes, ocultar, suspender y banear |
| 5 | Materias y agenda | 25–27 nov | PDF y descripción por materia; recordatorios con fecha y hora en el calendario |
| 6 | Publicación | 27–29 nov | Sitio con dominio y HTTPS, contenedores en un servidor, aviso de privacidad publicado, respaldos con `pg_dump` y una restauración probada |
| 7 | Cierre y margen | 30 nov – 4 dic | Fases documentadas en el repo, diagrama ER, capturas, demo y arreglos de último momento |

**Si no da el tiempo, se recorta en este orden** (confirmado): agenda → PDFs y descripciones → cédula → rúbrica. **Mínimo para entregar:** fases 1, 2, 3 y 6.

---

## Fase 0 — Lo que tienes que hacer tú

1. ~~Crear el repo~~ ✅ `pablo140706/Gestorix`, público, clonado en `C:\db\repos\proyectos\gestorix`.
2. ~~Darle acceso a Claude a `pablo140706`~~ ✅ (2026-11-08).
3. **Verificar Docker Desktop** en la PC: `docker --version` y `docker compose version`. Si no está, instalarlo con WSL2 antes de la Fase 1.
4. **Pedir el GitHub Student Pack** (servidor y dominio). Pasos en el mensaje de la sesión del 2026-11-08.
5. **Correo:** se usa **uno que el usuario ya tiene**, como contacto del aviso de privacidad y como remitente. Él lo pone en el aviso y en `.env`.
6. **Elegir el servicio de envío** para la verificación y el "olvidé mi contraseña". Recomiendo **Brevo** (plan gratuito, sin tarjeta) o, si ese correo es de Gmail, una **contraseña de aplicación**.
7. **Datos:**
   - cupos actualizados de las 3 carreras (HTML de SAES);
   - quién es el profe de `6CM5`;
   - los PDFs de plan sintético, uno por materia;
   - métricas de 73 profes y 65 links de MisProfesores, cuando los tengas;
   - cédulas: las capturas tú en pgAdmin cuando ya exista la base.

## Fase 0 — Preguntas que quedan

1. ~~Subir la versión con calendario~~ ✅ `pablo140706/iscweb-inicio`, rama `feat/multi-carrera-ia-lcd`, commit `2419470`.
2. ~~Correo de contacto~~ ✅ Uno que ya tiene el usuario. Falta: ¿qué nombre va como responsable? Por defecto, "Gestorix, proyecto escolar".

---

## Ya resuelto

| Tema | Decisión |
|---|---|
| Nombre | Gestorix (repo y sitio) |
| Dueño | El usuario, solo |
| Repo | `pablo140706/Gestorix`, público, limpio: sin historial ni archivos del iscweb viejo. Local: `C:\db\repos\proyectos\gestorix` |
| Dónde se trabaja | En la PC, que tiene la versión buena de iscweb (con calendario) |
| Entrega | Primera semana de diciembre, en un sitio web |
| Stack | Como Seismic: `php:8.2-apache` + `postgres:17` + pgAdmin, `sql/` numerado, `src/` servido por Apache. Sin framework |
| Front | Vanilla JS de iscweb, leyendo de la API |
| Fuente | HTML de SAES pegado → importador en Docker → base. Después se edita en pgAdmin |
| CSV | Obsoletos, salvo para la carga inicial (`CLAUDE.md` §3) |
| Esquema de la P3 | Solo referencia |
| Carga | En UA: mínima 4, media 7 (ISC) o 6 (IA, LCD), máxima 9. Aviso arriba de la media. Sin situación escolar |
| Cursos | 2 (ordinario y recurse). Tras reprobar el ordinario: recurse o ETS. Tras reprobar el recurse: ETS obligatorio. El ETS aprobado cuenta como aprobada y entra al promedio |
| Optativas | ISC por rama. IA y LCD solo en el semestre de su PDF; rutas solo con las parejas obvias |
| Seriación | ISC oficial + propuesta IA/LCD aprobada. Solo avisa |
| Cupo | 40 de 2.º en adelante, 36 en 1.º |
| Sin cuenta | Se puede usar la app; la cuenta guarda de forma permanente y permite comentar |
| Registro | Cualquier correo, con verificación. Alias generado y cambiable. Carrera fija |
| Privacidad | Sin boleta, teléfono ni nombre. El correo solo lo ven moderadores y admins |
| Comentarios | Sobre el profesor, con etiqueta de la materia (elegida de las suyas). Los que quiera cada usuario, máximo 500 caracteres. Edición en 24 h. Con rúbrica |
| Dificultad | Escala 0–10 (JURADO 6.4 y JUÁREZ LEÓN 6.1 son reales). LEVARIO corregido a 3.5 |
| Recordatorios | Solo en el calendario, sin avisos |
| Moderación | Ocultar, suspender y banear. El admin (tú) nombra moderadores |
| Cédula | La capturas tú |
| Plan sintético | Un PDF por materia; descripción generada por Claude desde el PDF |
| Agenda | Recordatorios con fecha y hora |
| Profesor sin asignar | Se guarda sin profesor y se corrige a mano |
| Cifras | 665 ofertas, 276 maestros |
| Correcciones | OLALDE 8.3 y LEVARIO 3.5 (más las de LUNA, MÁRQUEZ, BARRALES y TELLEZ) |
| Carga máxima | 9 UA, confirmado |
| Importar avance de iscweb | No hace falta: solo lo usas tú |
| Prácticas 4–5 | Ya entregadas; no se retoman |
| Recortes | Agenda → PDFs → cédula → rúbrica |
| Nada se borra | Ni del prototipo ni de iscweb |
