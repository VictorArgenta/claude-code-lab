# Sesión 03 — Script New-KickoffPPT.ps1

**Fecha:** 2026-06-21

## Objetivo
Crear un script que genere un PowerPoint de kickoff EPM de 7 diapositivas (portada, agenda,
objetivos, alcance, equipo, hitos/timeline y próximos pasos), reutilizable en proyectos reales.

## Qué hicimos
- Diseño en dos capas siguiendo las convenciones del repo (PowerShell PascalCase + Python snake_case):
  - `scripts/New-KickoffPPT.ps1`: envoltorio de orquestación. Valida parámetros, comprueba que
    existan `python` y `python-pptx`, construye la llamada y reporta la ruta absoluta del `.pptx`.
    Parámetros: `-ClientName` (obligatorio), `-EPMTool` (`ValidateSet` OneStream/OracleEPM/Anaplan,
    por defecto OneStream), `-ProjectDate` (`yyyy-MM-dd`, por defecto hoy), `-TeamLead` (opcional) y
    `-OutputPath` (opcional, por defecto `$PWD`).
  - `scripts/build_kickoff_ppt.py`: generador con `python-pptx`. 7 diapositivas en formato 16:9,
    plantilla profesional con placeholders editables (no inventa datos del cliente). El timeline
    reutiliza las 7 fases EPM coherentes con `New-EPMProject.ps1`.
- Instalada la dependencia `python-pptx 1.0.2` con `python -m pip install --user`.
- Documentado el script en `README.md` (parámetros, requisitos y ejemplos).

## Verificación
Ejecuté el script con `-ClientName "ACME Corp" -EPMTool OracleEPM -TeamLead "Victor Argenta"` sobre
una carpeta temporal: generó el `.pptx` y, al abrirlo con `python-pptx`, confirmé **7 diapositivas**.
Corregí un `SyntaxWarning` del docstring (secuencia `\K` por una ruta con backslash); ahora compila
limpio con `python -W error::SyntaxWarning`.

## Conceptos aprendidos
- **Separación de responsabilidades PS + Python:** PowerShell no genera `.pptx`, así que el `.ps1`
  orquesta (validación, comprobación de dependencias, reporte) y delega la generación en Python.
- **`$PSScriptRoot` para localizar el `.py`:** el generador vive junto al `.ps1`, no donde se
  ejecuta, así que se resuelve con `$PSScriptRoot` (a diferencia de `$PWD` para la salida).
- **Comprobación de dependencias antes de actuar:** `python -c "import pptx"` y `$LASTEXITCODE`
  permiten fallar con un mensaje claro si falta el paquete.
- **Escapes en literales Python:** una ruta `.\Kickoff` dentro de un string normal dispara
  `SyntaxWarning` por `\K`; conviene usar `/`, raw strings o doblar la barra.

## Pendiente / próximos pasos
- Posibilidad de aceptar una plantilla `.pptx` corporativa de base (branding) en lugar del tema por
  defecto de python-pptx.
- Permitir rellenar contenido real (objetivos, equipo) desde un fichero de datos en vez de placeholders.
