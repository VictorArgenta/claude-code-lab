# claude-code-lab

Repositorio sandbox para aprender **Claude Code** a lo largo de un curso de 20 sesiones. Aquí se guardan notas, ejercicios, scripts y prototipos que se van produciendo durante el curso, de forma que cada sesión deje un rastro reproducible y consultable más adelante. La idea es experimentar sin miedo: probar comandos, escribir skills, configurar servidores MCP y romper cosas en un entorno aislado pensado únicamente para el aprendizaje.

**Claude Code** es la herramienta de línea de comandos oficial de Anthropic para programar de forma agéntica: un asistente de IA que vive en la terminal (y también en el escritorio, la web y los IDEs) y que puede leer y editar archivos, ejecutar comandos, usar herramientas externas mediante MCP y automatizar tareas de ingeniería de software. En este repositorio se explora cómo sacarle partido —desde lo básico hasta skills personalizadas y servidores MCP— usando este propio repo como banco de pruebas.

## Estructura de carpetas

| Carpeta       | Contenido                                                            |
|---------------|---------------------------------------------------------------------|
| `/docs`       | Documentación del curso y notas de cada sesión.                     |
| `/scripts`    | Scripts de automatización (PowerShell, Python).                     |
| `/skills`     | Skills personales de Claude Code en formato `.md`.                  |
| `/mcp`        | Configuración y prototipos de servidores MCP.                       |
| `/exercises`  | Ejercicios organizados por sesión.                                  |

## Scripts

### `scripts/New-EPMProject.ps1`

Crea la estructura estándar de un nuevo proyecto EPM (Enterprise Performance Management) en el directorio donde se ejecuta: una carpeta con el nombre del cliente que contiene las 7 subcarpetas de fase (`01-kickoff`, `02-functional-specs`, `03-data-model`, `04-testing`, `05-training`, `06-go-live`, `07-hypercare`) y un `README.md` con el cliente, la herramienta EPM y la fecha de creación.

**Parámetros**

| Parámetro      | Obligatorio | Por defecto  | Descripción                                                                 |
|----------------|-------------|--------------|-----------------------------------------------------------------------------|
| `-ClientName`  | Sí          | —            | Nombre del cliente; se usa como nombre de la carpeta raíz del proyecto.      |
| `-Tool`        | No          | `OneStream`  | Herramienta EPM que se documenta en el `README.md`.                         |
| `-Force`       | No          | —            | Si la carpeta ya existe, reconcilia (crea solo lo que falte, sin sobreescribir). |

Si la carpeta del cliente ya existe, el script avisa y se detiene sin tocar nada; con `-Force` crea únicamente los elementos que falten y conserva el `README.md` existente.

**Ejemplos**

```powershell
# Proyecto básico (herramienta OneStream por defecto)
.\scripts\New-EPMProject.ps1 -ClientName "ACME"

# Indicando otra herramienta EPM
.\scripts\New-EPMProject.ps1 -ClientName "ACME" -Tool "Anaplan"

# Reconciliar una carpeta ya existente
.\scripts\New-EPMProject.ps1 -ClientName "ACME" -Force

# Ayuda completa del script
Get-Help .\scripts\New-EPMProject.ps1 -Full
```

Compatible con Windows PowerShell 5.1; no requiere módulos externos.

## Uso

Clona el repositorio y abre Claude Code en la raíz del proyecto. Cada carpeta es independiente; usa la que corresponda según la sesión del curso en la que estés trabajando.
