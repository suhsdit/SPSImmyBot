# This function is used to help update the module while developing and testing...
Function Update-SPSImmyBot {
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    Param(
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$false,
            Position=0)]
        [string]$config
    )
    Write-Host "[X] Removing SPSImmyBot Module..." -ForegroundColor Green
    Get-Module SPSImmyBot | Remove-Module
    Write-Host "[X] Importing SPSImmyBot Module from .\SPSImmyBot..." -ForegroundColor Green
    Import-Module .\SPSImmyBot
    Write-Host "[X] Setting SPSImmyBot config to $config..." -ForegroundColor Green
    Set-SPSImmyBotConfiguration $config
    Write-Host "[X] Updated SPSImmyBot ready to use. Using Config:" -ForegroundColor Green
    Get-SPSImmyBotConfiguration
}