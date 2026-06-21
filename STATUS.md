# STATUS — Curso Claude Code (20 sesiones)

Estado del progreso del curso y rastro de artefactos por sesión. Repositorio sandbox
`VictorArgenta/claude-code-lab`.

## Progreso por sesión

| Sesión | Título | Estado | Artefactos |
|--------|--------|--------|------------|
| 01 | Estructura inicial del repositorio | Completada | Estructura de carpetas (`/docs`, `/scripts`, `/skills`, `/mcp`, `/exercises`), `README.md`, `.gitignore`, `.gitattributes`, `docs/sesion-01.md` |
| 02 | Script New-EPMProject.ps1 | Completada | `scripts/New-EPMProject.ps1`, `docs/sesion-02.md` |
| 03 | Script New-KickoffPPT.ps1 | Completada | `scripts/New-KickoffPPT.ps1`, `scripts/build_kickoff_ppt.py`, sección en `README.md`, `docs/sesion-03.md` |
| 04 | CLAUDE.md del proyecto | Completada | `CLAUDE.md` (contexto del repo, criterio de permisos, convenciones) — sin nota de sesión en `/docs` |
| 05 | Formato Deloitte en New-KickoffPPT.ps1 | Completada | Sección `## Formato de documentacion` en `CLAUDE.md`, estilos Deloitte en `build_kickoff_ppt.py` y timestamp Madrid en `New-KickoffPPT.ps1`, `docs/sesion-05.md` |
| 06 | Por definir | Pendiente | — |
| 07 | Por definir | Pendiente | — |
| 08 | Por definir | Pendiente | — |
| 09 | Por definir | Pendiente | — |
| 10 | Por definir | Pendiente | — |
| 11 | Por definir | Pendiente | — |
| 12 | Por definir | Pendiente | — |
| 13 | Por definir | Pendiente | — |
| 14 | Por definir | Pendiente | — |
| 15 | Por definir | Pendiente | — |
| 16 | Por definir | Pendiente | — |
| 17 | Por definir | Pendiente | — |
| 18 | Por definir | Pendiente | — |
| 19 | Por definir | Pendiente | — |
| 20 | Por definir | Pendiente | — |

## Toolkit acumulado

### Scripts
- `scripts/New-EPMProject.ps1` — crea la estructura estándar de un proyecto EPM (7 fases + README).
- `scripts/New-KickoffPPT.ps1` — wrapper PowerShell que genera un PowerPoint de kickoff EPM con formato Deloitte y nombre con timestamp en hora de Madrid.
- `scripts/build_kickoff_ppt.py` — generador Python (python-pptx) de las 7 diapositivas del kickoff.

### MCP servers
- **Tavily** — búsqueda web para research, activo a nivel de sesión (configuración global, no en el repo).
- `/mcp` — carpeta reservada para configuraciones y prototipos de servidores MCP; aún sin artefactos propios.

### Configuración
- `CLAUDE.md` — instrucciones del proyecto: convenciones de entorno, commits, permisos, contexto EPM y formato de documentación Deloitte.
- `README.md` — documentación del repo y detalle de cada script.
- `.gitignore` — stack mixto Node.js + Python + Windows.
- `.gitattributes` — normalización de finales de línea (LF en repo, CRLF para `.ps1`/`.bat`/`.cmd`).
- `.claude/settings.local.json` — ajustes locales de Claude Code (no versionado).

### Skills
- `/skills` — carpeta reservada para skills personales de Claude Code; aún sin artefactos propios.

### Dependencias Python
- `python-pptx` — requerida por `build_kickoff_ppt.py` (instalada con `pip install --user`).
