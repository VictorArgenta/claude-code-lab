# Sesión 01 — Estructura inicial del repositorio

**Fecha:** 2026-06-09

## Objetivo
Montar el repositorio sandbox del curso: estructura de carpetas, README, `.gitignore` y primer commit.

## Qué hicimos
- Creé las carpetas base del repo: `/docs`, `/scripts`, `/skills`, `/mcp`, `/exercises`.
  - Cada una lleva un `.gitkeep` porque Git no versiona carpetas vacías por sí solo.
- Escribí el `README.md` de la raíz: explica para qué sirve el repo, qué es Claude Code y qué contiene cada carpeta.
- Añadí un `.gitignore` para un stack mixto (Node.js + Python + Windows), con excepción para `.env.example`.
- Commit: `feat: estructura inicial del repositorio` (`ba861cb`).

## Extra
- Añadí un `.gitattributes` para normalizar finales de línea (LF en el repo, CRLF para `.ps1`/`.bat`/`.cmd`).
  - Commit: `chore: añadir .gitattributes para normalizar finales de linea` (`3e9b910`).
- `git add --renormalize .` no produjo cambios: los archivos ya estaban guardados con LF.

## Conceptos aprendidos
- **Ciclo de Claude Code:** leer → editar → ejecutar → verificar.
- **`.gitkeep`** como convención para versionar carpetas vacías.
- **`.gitignore` vs `.gitattributes`:** uno decide qué se ignora; el otro, cómo se tratan los archivos versionados (finales de línea, binarios).
- Diferencia entre lo que Git **guarda** en el repo (LF) y lo que hay en la **copia de trabajo** en disco (CRLF en Windows).

## Pendiente / próximos pasos
- Posible `CLAUDE.md` del proyecto en una próxima sesión para dar instrucciones persistentes.
