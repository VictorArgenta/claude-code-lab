# Sesión 02 — Script New-EPMProject.ps1

**Fecha:** 2026-06-09

## Objetivo
Crear un script PowerShell que estandarice el arranque de proyectos EPM: generar siempre la misma
estructura de carpetas y un README de cabecera para cada cliente nuevo.

## Qué hicimos
- Creé `scripts/New-EPMProject.ps1`, que:
  - Acepta `-ClientName` (obligatorio), `-Tool` (opcional, por defecto `OneStream`) y `-Force` (switch).
  - Crea la carpeta del cliente en el directorio donde se ejecuta (`$PWD`).
  - Genera 7 subcarpetas de fase: `01-kickoff`, `02-functional-specs`, `03-data-model`,
    `04-testing`, `05-training`, `06-go-live`, `07-hypercare`.
  - Escribe un `README.md` con cliente, herramienta EPM, fecha de hoy y una tabla con el propósito
    de cada fase.
  - Si la carpeta ya existe: **avisa y se detiene** sin tocar nada; con `-Force` reconcilia (crea
    solo lo que falte, nunca borra ni sobreescribe).
  - Muestra confirmación final en verde con la ruta absoluta y las subcarpetas creadas.
- Incluye comment-based help (`Get-Help`) y es compatible con Windows PowerShell 5.1.

## Verificación
Probé en una carpeta temporal todos los escenarios: creación básica, inspección de subcarpetas,
contenido del README, re-ejecución sin `-Force` (advierte y sale), con `-Force` (reconcilia y
conserva el README) y con `-Tool "Anaplan"`. Todo correcto.

## Conceptos aprendidos
- **Codificación y BOM:** un `.ps1` sin BOM se interpreta como Windows-1252 al parsearlo en
  PowerShell 5.1, así que un guión largo `—` salía como mojibake (`â€"`). Solución: usar ASCII en
  el texto del script (guiones normales, sin acentos en las cadenas literales del código).
- **Idempotencia:** comprobar con `Test-Path` antes de crear evita errores y permite reconciliar
  sin destruir trabajo previo.
- **`Write-Host`/`Write-Warning` vs `Write-Output`:** los mensajes para el usuario no deben ir al
  pipeline; `Write-Output` ensuciaría la salida del script.
- **`$PWD` vs `$PSScriptRoot`:** se usó `$PWD` a propósito para crear el proyecto donde se ejecuta
  el script, no donde vive el script.

## Pendiente / próximos pasos
- Posibles tests automatizados con Pester si el script crece.
