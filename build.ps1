#Install-Module -Name Configuration -Repository PSGallery -Force

$buildVersion = $env:BUILDVER
$moduleName = 'SPSImmyBot'
$manifestPath = Join-Path -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY/$moduleName -ChildPath "$moduleName.psd1"

#Update-Metadata -Path $manifestPath -PropertyName ModuleVersion -Value $buildVersion

## Update build version in manifest
$manifestContent = Get-Content -Path $manifestPath -Raw
$manifestContent = $manifestContent -replace '<ModuleVersion>', $buildVersion

## Find all of the public functions
#$publicFuncFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'public'
#if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {     $funcStrings = "'$($publicFunctionNames -join "','")'"
#} else {
#    $funcStrings = $null
#}
## Add all public functions to FunctionsToExport attribute
#$manifestContent = $manifestContent -replace "''", $funcStrings
$manifestContent | Set-Content -Path $manifestPath