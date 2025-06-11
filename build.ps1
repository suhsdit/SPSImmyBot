#Install-Module -Name Configuration -Repository PSGallery -Force

"List all environment variables"
Get-ChildItem Env: | foreach { "$($_.Name): $($_.Value)" }

"End of environment variables"

"env build ver: $($env:buildVer)"

$buildVersion = $env:buildVer
$moduleName = 'SPSImmyBot'
$manifestPath = Join-Path -Path $PWD/$moduleName -ChildPath "$moduleName.psd1"

"buildVersion: $buildVersion"
"manifestPath: $manifestPath"
"WorkingDir: $PWD"

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