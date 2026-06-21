# Sesión 05 — Formato Deloitte en New-KickoffPPT.ps1

**Fecha:** 2026-06-21

## Objetivo
Definir un estándar de formato corporativo (paleta y tipografía Deloitte) para cualquier documento
generado en el repo y aplicarlo al generador de PowerPoint de kickoff, incorporando además un
nombrado de ficheros con timestamp en hora de Madrid.

## Qué hicimos
- Añadí a `CLAUDE.md` la sección `## Formato de documentacion` con:
  - La **paleta Deloitte** obligatoria (fondo blanco, negro `#26282A`, grises de contraste, verde
    acento `#86BC25`, verde oscuro `#046A38`, off-white `#F6F6F6` y rojo `#DA291C` solo para riesgos).
  - Estilos para **PowerPoint** (Arial, fondo blanco, línea verde de 3pt en el header, título de
    portada 28pt y de contenido 20pt en negro Deloitte), **Word** y **Markdown**.
  - Convención de **nombrado con timestamp** `NOMBRE_AAAAMMDD_HHMM` en zona `Europe/Madrid`.
- Regeneré `scripts/build_kickoff_ppt.py` aplicando esos estilos: fondo blanco explícito, fuente
  Arial en todos los runs, línea verde de header por slide, títulos en negro Deloitte y cuerpo en
  gris medio `#63666A`.
- Actualicé `scripts/New-KickoffPPT.ps1` para nombrar el `.pptx` con sufijo de timestamp en hora de
  Madrid, usando `[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), "Romance Standard Time")`.

## Verificación
Ejecuté el script con `-ClientName 'Empresa-Demo' -EPMTool OneStream` guardando en
`exercises/sesion-05/`. Generó `Kickoff-Empresa-Demo_20260621_1338.pptx` con 7 diapositivas en
formato 16:9. Leyendo el fichero con `python-pptx` confirmé que la línea de header es `86BC25` y que
el título de portada es Arial, 28pt, bold y color `26282A`. El `.pptx` queda como artefacto de
prueba sin versionar.

## Conceptos aprendidos
- **Zona horaria en Windows:** `Europe/Madrid` (nombre IANA) se corresponde con `Romance Standard
  Time` en el catálogo de Windows; convertir desde `Get-Date` evita depender de la hora local del
  equipo o de UTC.
- **Estilo programático en python-pptx:** el formato corporativo se aplica run a run (`font.name`,
  `font.size`, `font.color.rgb`, `bold`); no hay un "tema" global, así que conviene centralizar
  colores y helpers de estilo.
- **CLAUDE.md como fuente de estándares:** documentar la paleta en `CLAUDE.md` permite que cualquier
  generación futura (PPT, Word, Markdown) parta de la misma guía sin repetir la decisión.

## Pendiente / próximos pasos
- Aceptar una plantilla `.pptx` corporativa de base (branding) en lugar del tema por defecto.
- Aplicar el mismo estándar Deloitte a futuros generadores de Word/Markdown del repo.
