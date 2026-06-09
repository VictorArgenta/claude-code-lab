# claude-code-lab

Repositorio **sandbox de aprendizaje** de Claude Code a lo largo de un curso de 20 sesiones. No es codigo de produccion: el objetivo es experimentar (comandos, skills, servidores MCP, scripts) y dejar de cada sesion un rastro reproducible.

## Estructura de carpetas

| Carpeta       | Contenido                                            |
|---------------|------------------------------------------------------|
| `/docs`       | Documentacion del curso y notas de cada sesion.      |
| `/scripts`    | Scripts de automatizacion (PowerShell, Python).      |
| `/skills`     | Skills personales de Claude Code en formato `.md`.   |
| `/mcp`        | Configuracion y prototipos de servidores MCP.        |
| `/exercises`  | Ejercicios organizados por sesion.                   |

El detalle de cada script (parametros, ejemplos de uso) vive en `README.md`; no lo dupliques aqui.

## Convenciones del entorno

- Shell objetivo de los scripts: **Windows PowerShell 5.1**.
- Scripts `.ps1` en **ASCII**: sin acentos ni guion largo (`—`) en literales de codigo. Un `.ps1` sin BOM se parsea como Windows-1252 en PS 5.1 y produce mojibake.
- Mensajes al usuario con `Write-Host` / `Write-Warning`, nunca `Write-Output` (no ensuciar el pipeline).
- `$PWD` vs `$PSScriptRoot` segun el caso: `$PWD` para actuar donde se ejecuta el script, `$PSScriptRoot` para actuar donde vive.

## Convencion de commits

Conventional Commits en espanol: `feat:`, `docs:`, `chore:`, `fix:`, etc. Mensaje en minuscula y en castellano.

## Flujo de cada sesion

Cada sesion deja nota en `/docs/sesion-NN.md` con la estructura: **Objetivo**, **Que hicimos**, **Verificacion**, **Conceptos aprendidos** y **Pendiente / proximos pasos**.

## Criterio de permisos

- plan: tarea nueva o compleja, no se como la va a abordar el agente
- acceptEdits: modo de trabajo habitual en desarrollo y edicion de ficheros
- auto: tareas validadas, commits, push, operaciones conocidas y reversibles
- bypassPermissions: nunca en esta maquina
