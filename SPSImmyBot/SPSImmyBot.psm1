# Template for module courtesy of RamblingCookieMonster
#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable


# Export Public functions ($Public.BaseName) for WIP modules

# Immy Bot Config info, set script variables
New-Variable -Name SPSImmyBotConfigName -Scope Script -Force
New-Variable -Name SPSImmyBotConfigRoot -Scope Script -Force
$SPSImmyBotConfigRoot = "$Env:USERPROFILE\AppData\Local\powershell\SPSImmyBot"
New-Variable -Name SPSImmyBotConfigDir -Scope Script -Force
New-Variable -Name Config -Scope Script -Force
New-Variable -Name APIKey -Scope Script -Force

Export-ModuleMember -Function $Public.Basename