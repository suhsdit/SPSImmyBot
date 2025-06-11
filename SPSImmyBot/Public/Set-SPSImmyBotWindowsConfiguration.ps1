Function Set-SPSImmyBotWindowsConfiguration {
<#
.SYNOPSIS
    Set the configuration to use for the SPSImmyBot Module
.DESCRIPTION
    Set the configuration to use for the SPSImmyBot Module
.EXAMPLE
    Set-SPSImmyBotWindowsConfiguration -Name suhsd
    Set the configuration to Name
.PARAMETER
.INPUTS
.OUTPUTS
.NOTES
.LINK
#>
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    Param(
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            # HelpMessage='HelpMessage',
            Position=0)]
        [String]$Name
    )

    Begin{
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
    }
    Process {
        try{
            Write-Verbose -Message "Changing Config from $($Script:SPSImmyBotConfigName) to $($Name)"
            $Script:SPSImmyBotConfigName    = $Name
            $Script:SPSImmyBotConfigDir     = "$Env:USERPROFILE\AppData\Local\powershell\SPSImmyBot\$Name"

            Write-Verbose -Message "Config dir: $SPSImmyBotConfigDir"
            Write-Verbose -Message "Importing config.json"
            $Script:Config                  = Get-Content -Raw -Path "$Script:SPSImmyBotConfigDir\config.json" | ConvertFrom-Json
            $Script:BaseURL                  = "https://$($Config.ImmyBotSubdomain).immy.bot"
            $Script:AzureDomain             = $Config.AzureDomain
            $Script:ImmyBotSubdomain        = $Config.ImmyBotSubdomain
            $Script:ClientID                = $Config.ClientID
            $Script:Secret                  = Import-Clixml -Path "$Script:SPSImmyBotConfigDir\secret.xml"
            $Script:Secret                  = $Secret.GetNetworkCredential().Password
            Write-Verbose -Message "Importing Azure App Secret.xml"

            $Script:TokenEndpointUri = [uri](Invoke-RestMethod "https://login.microsoftonline.com/$($AzureDomain)/.well-known/openid-configuration").token_endpoint 
            $Script:TenantID = ($TokenEndpointUri.Segments | Select-Object -Skip 1 -First 1).Replace("/","") 

            $Script:Token = Get-ImmyBotApiAuthToken -ApplicationId $ClientID -TenantId $TenantID -Secret $Secret -ApiEndpointUri $BaseURL
            $Script:ImmyBotApiAuthHeader = @{
                "authorization"="Bearer $($Token.access_token)"
              }
        }
        catch{
            Write-Error -Message "$_ went wrong."
        }
    }
    End{
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}