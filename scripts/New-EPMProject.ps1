<#
.SYNOPSIS
    Crea la estructura estandar de carpetas para un nuevo proyecto EPM.

.DESCRIPTION
    Genera, en el directorio donde se ejecuta el script, una carpeta con el nombre
    del cliente y dentro las 7 subcarpetas de fase de un proyecto EPM, junto con un
    README.md de cabecera (cliente, herramienta EPM y fecha de creacion).

    Si la carpeta del cliente ya existe, el script avisa y se detiene sin tocar nada.
    Con el switch -Force reconcilia la carpeta existente: crea solo las subcarpetas o
    el README que falten, sin borrar ni sobreescribir contenido existente.

.PARAMETER ClientName
    Nombre del cliente. Obligatorio. Se usa como nombre de la carpeta raiz del proyecto.

.PARAMETER Tool
    Herramienta EPM del proyecto. Opcional. Por defecto 'OneStream'.

.PARAMETER Force
    Si la carpeta del cliente ya existe, permite continuar y reconciliar lo que falte
    en lugar de detenerse. Nunca borra ni sobreescribe contenido existente.

.EXAMPLE
    .\New-EPMProject.ps1 -ClientName "ACME"
    Crea la carpeta ACME con la estructura completa y un README para OneStream.

.EXAMPLE
    .\New-EPMProject.ps1 -ClientName "ACME" -Tool "Anaplan"
    Igual que el anterior, pero el README indica Anaplan como herramienta EPM.

.EXAMPLE
    .\New-EPMProject.ps1 -ClientName "ACME" -Force
    Reconcilia una carpeta ACME ya existente: crea solo lo que falte.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ClientName,

    [Parameter(Mandatory = $false)]
    [string]$Tool = 'OneStream',

    [switch]$Force
)

# Estructura fija de subcarpetas (el orden define las fases del proyecto).
$subFolders = @(
    '01-kickoff',
    '02-functional-specs',
    '03-data-model',
    '04-testing',
    '05-training',
    '06-go-live',
    '07-hypercare'
)

# Proposito de cada fase, para documentarlo en el README.
$folderPurpose = [ordered]@{
    '01-kickoff'           = 'Arranque del proyecto: alcance, equipo, planificacion.'
    '02-functional-specs'  = 'Especificaciones funcionales y requisitos.'
    '03-data-model'        = 'Diseno del modelo de datos y dimensiones.'
    '04-testing'           = 'Casos de prueba, UAT y evidencias.'
    '05-training'          = 'Material y sesiones de formacion.'
    '06-go-live'           = 'Puesta en produccion y checklist de salida.'
    '07-hypercare'         = 'Soporte intensivo posterior al go-live.'
}

# La carpeta del cliente se crea en el directorio desde donde se ejecuta el script.
$targetPath = Join-Path -Path $PWD.Path -ChildPath $ClientName

# Comprobacion de existencia antes de crear nada.
if (Test-Path -LiteralPath $targetPath) {
    if (-not $Force) {
        Write-Warning "La carpeta '$ClientName' ya existe en '$($PWD.Path)'. No se ha modificado nada."
        Write-Warning "Usa -Force para reconciliar (crear solo lo que falte sin sobreescribir)."
        return
    }
    Write-Warning "La carpeta '$ClientName' ya existe. Reconciliando: se crearan solo los elementos que falten."
}
else {
    New-Item -ItemType Directory -Path $targetPath | Out-Null
}

# Crear subcarpetas de forma idempotente (no pisa ni lanza error si ya existen).
$createdFolders = @()
foreach ($folder in $subFolders) {
    $folderPath = Join-Path -Path $targetPath -ChildPath $folder
    if (-not (Test-Path -LiteralPath $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        $createdFolders += $folder
    }
}

# Generar el README.md (sin sobreescribir si ya existe).
$readmePath = Join-Path -Path $targetPath -ChildPath 'README.md'
$today = Get-Date -Format 'yyyy-MM-dd'

if (Test-Path -LiteralPath $readmePath) {
    Write-Warning "El README.md ya existe; se conserva el actual."
}
else {
    # Construir la tabla de estructura a partir de las subcarpetas y sus propositos.
    $tableRows = foreach ($folder in $subFolders) {
        "| $folder | $($folderPurpose[$folder]) |"
    }
    $tableBlock = $tableRows -join "`r`n"

    $readmeContent = @"
# Proyecto EPM - $ClientName

- **Cliente:** $ClientName
- **Herramienta EPM:** $Tool
- **Fecha de creacion:** $today

## Estructura del proyecto

| Carpeta | Proposito |
| ------- | --------- |
$tableBlock
"@

    Set-Content -LiteralPath $readmePath -Value $readmeContent -Encoding UTF8
}

# Confirmacion final con la ruta absoluta creada.
$absolutePath = (Resolve-Path -LiteralPath $targetPath).Path
Write-Host ""
Write-Host "Proyecto EPM creado correctamente." -ForegroundColor Green
Write-Host "  Cliente:     $ClientName"
Write-Host "  Herramienta: $Tool"
Write-Host "  Ruta:        $absolutePath" -ForegroundColor Green
if ($createdFolders.Count -gt 0) {
    Write-Host "  Subcarpetas creadas: $($createdFolders -join ', ')"
}
else {
    Write-Host "  Subcarpetas creadas: ninguna (ya existian todas)."
}
