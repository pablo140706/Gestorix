# Cómo cargar un periodo nuevo (por ejemplo 27/2)

Cuando SAES publique los horarios del siguiente periodo. Todo se corre en la carpeta del proyecto,
con Docker Desktop prendido.

> **Antes de empezar, saca un respaldo** de la base ([respaldo.md](respaldo.md)). Si algo sale mal,
> regresas a como estaba.

## 0. Qué cambia en la app

- El **periodo vigente** es el más reciente que tiene ofertas. En cuanto cargues 27/2, la app
  muestra los horarios de 27/2 y 27/1 pasa al historial.
- Los horarios que la gente armó con ofertas de 27/1 **ya no se muestran** (el horario guardado es
  solo del periodo vigente). El avance y las calificaciones no se tocan.

## 1. El periodo debe existir en la base

`27/2` ya está (25 ene – 22 jun 2027). Para uno que no esté, en pgAdmin:

```sql
INSERT INTO periodo (codigo, inicio, fin) VALUES ('28/1', '2027-08-16', '2027-12-17');
```

## 2. Pegar el HTML de SAES

En SAES copia el HTML de la tabla (o guarda la página) y **reemplaza** estos archivos (git guarda
las versiones de 27/1 en su historial):

| Archivo | Qué es |
|---|---|
| `data/isc/horario-m.html`, `horario-v.html` | Horarios de ISC, matutino y vespertino |
| `data/ia/…` y `data/lcd/…` | Lo mismo para IA y LCD |
| `data/isc/cupos.html` (y `ia`, `lcd`) | Cupos e inscritos |

## 3. Cargar horarios y cupos

```powershell
docker compose run --rm web php importador/horarios.php 27/2
```
```powershell
docker compose run --rm web php importador/cupos.php 27/2
```

Lee lo que dicen al final: ofertas nuevas, profes nuevos y avisos (materias o profes que no cruzaron).
`horarios.php` se puede repetir sin duplicar. `cupos.php` deja la tabla de cupos igual que el HTML.

## 4. Salones con el PDF oficial (opcional)

Guarda el PDF "Distribución de salones" como `data/salones/27-2.pdf` y, en Git Bash:

```bash
pdftotext -table -enc UTF-8 data/salones/27-2.pdf data/salones/27-2.txt
docker compose run --rm web php importador/salones.php 27/2
```

## 5. Ofertas que no se deben cargar

Si SAES trae algo que no se abrió, agrégalo a `data/excluir.csv` (periodo, grupo, materia, motivo)
y vuelve a correr el paso 3.

## 6. Revisar

- Abre la app: arriba debe decir 27/2 y los horarios nuevos deben salir en Maestros y en Generar horario.
- En pgAdmin: `SELECT count(*) FROM oferta WHERE periodo = '27/2';`
- Corre las pruebas: `docker run --rm -v "${PWD}:/app" -w /app node:22-alpine node pruebas/reglas.test.js`
- Saca otro respaldo y, si vas a usar la laptop, llévate ese.
