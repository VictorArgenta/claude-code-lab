<#
.SYNOPSIS
    Genera un PowerPoint de kickoff EPM de 7 diapositivas.

.DESCRIPTION
    Orquesta la generacion de una presentacion de kickoff invocando el script
    Python build_kickoff_ppt.py (que usa python-pptx). El .ps1 valida los
    parametros, comprueba que python y python-pptx esten disponibles, construye
    la llamada y reporta la ruta absoluta del .pptx generado.

    Las 7 diapositivas son: portada, agenda, objetivos, alcance, equipo,
    hitos/timeline y proximos pasos. El contenido es una plantilla profesional
    con placeholders editables: no inventa datos del cliente.

.PARAMETER ClientName
    Nombre del cliente. Obligatorio. Aparece en la portada y da nombre al fichero.

.PARAMETER EPMTool
    Herramienta EPM. Opcional. Uno de OneStream, OracleEPM o Anaplan.
    Por defecto 'OneStream'.

.PARAMETER ProjectDate
    Fecha del proyecto en formato yyyy-MM-dd. Opcional. Por defecto la fecha de hoy.

.PARAMETER TeamLead
    Nombre del Team Lead del proyecto. Opcional. Se destaca en portada y equipo.

.PARAMETER OutputPath
    Carpeta donde se escribe el .pptx. Opcional. Por defecto el directorio actual.

.EXAMPLE
    .\New-KickoffPPT.ps1 -ClientName "ACME"
    Genera Kickoff-ACME-<fecha>.pptx en el directorio actual para OneStream.

.EXAMPLE
    .\New-KickoffPPT.ps1 -ClientName "ACME" -EPMTool OracleEPM -TeamLead "Victor Argenta"
    Igual pero para Oracle EPM y con Team Lead destacado.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ClientName,

    [Parameter(Mandatory = $false)]
    [ValidateSet('OneStream', 'OracleEPM', 'Anaplan')]
    [string]$EPMTool = 'OneStream',

    [Parameter(Mandatory = $false)]
    [ValidatePattern('^\d{4}-\d{2}-\d{2}$')]
    [string]$ProjectDate = (Get-Date -Format 'yyyy-MM-dd'),

    [Parameter(Mandatory = $false)]
    [string]$TeamLead = '',

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = $PWD.Path
)

# El script Python vive junto a este .ps1, no donde se ejecuta.
$pyScript = Join-Path -Path $PSScriptRoot -ChildPath 'build_kickoff_ppt.py'
if (-not (Test-Path -LiteralPath $pyScript)) {
    Write-Error "No se encuentra build_kickoff_ppt.py junto al script en '$PSScriptRoot'."
    return
}

# Comprobar que python esta en el PATH.
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Error "No se encuentra 'python' en el PATH. Instala Python 3 y vuelve a intentarlo."
    return
}

# Comprobar que python-pptx esta instalado antes de invocar el generador.
& python -c "import pptx" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Falta la dependencia python-pptx. Instalala con: python -m pip install --user python-pptx"
    return
}

# La carpeta de salida debe existir.
if (-not (Test-Path -LiteralPath $OutputPath)) {
    Write-Error "La carpeta de salida '$OutputPath' no existe."
    return
}

# Nombre de fichero seguro: Kickoff-<cliente>-<fecha>.pptx (sin caracteres invalidos).
$safeClient = ($ClientName -replace '[\\/:*?"<>|]', '_').Trim()
$fileName = "Kickoff-$safeClient-$ProjectDate.pptx"
$outputFile = Join-Path -Path (Resolve-Path -LiteralPath $OutputPath).Path -ChildPath $fileName

# Invocar el generador Python pasando los datos por argumentos.
$pyArgs = @(
    $pyScript,
    '--client', $ClientName,
    '--tool', $EPMTool,
    '--date', $ProjectDate,
    '--team-lead', $TeamLead,
    '--output', $outputFile
)
$stdout = & python @pyArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "La generacion del PowerPoint fallo. Detalle: $stdout"
    return
}

# Confirmacion final con la ruta absoluta del fichero generado.
Write-Host ""
Write-Host "PowerPoint de kickoff generado correctamente." -ForegroundColor Green
Write-Host "  Cliente:     $ClientName"
Write-Host "  Herramienta: $EPMTool"
Write-Host "  Fecha:       $ProjectDate"
if ($TeamLead) {
    Write-Host "  Team Lead:   $TeamLead"
}
Write-Host "  Fichero:     $outputFile" -ForegroundColor Green
