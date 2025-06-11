Function Set-SPSImmyBotConfiguration {
<#
.SYNOPSIS
    Set the configuration to use for the SPSImmyBot Module
.DESCRIPTION
    Set the configuration to use for the SPSImmyBot Module
.EXAMPLE
    Set-SPSImmyBotConfiguration -Name suhsd
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
        [String]$Name,
        
        [Parameter(Mandatory=$true)]
        [String]$AzureDomain,
        
        [Parameter(Mandatory=$true)]
        [String]$ImmyBotSubdomain,
        
        [Parameter(Mandatory=$true)]
        [String]$ClientID,

        [Parameter(Mandatory=$true)]
        [String]$Secret
    )
    Begin{
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"   
    }
    Process{
        try{
            $Script:SPSImmyBotConfigName    = $Name
            $Script:BaseURL                 = "https://$($ImmyBotSubdomain).immy.bot"
            $Script:AzureDomain             = $AzureDomain
            $Script:ImmyBotSubdomain        = $ImmyBotSubdomain
            $Script:ClientID                = $ClientID
            $Script:Secret                  = $Secret
            $Script:TokenEndpointUri        = [uri](Invoke-RestMethod "https://login.microsoftonline.com/$($AzureDomain)/.well-known/openid-configuration").token_endpoint 
            $Script:TenantID                = ($TokenEndpointUri.Segments | Select-Object -Skip 1 -First 1).Replace("/","") 
            $Script:Token                   = Get-ImmyBotApiAuthToken -ApplicationId $ClientID -TenantId $TenantID -Secret $Secret -ApiEndpointUri $BaseURL
            $Script:ImmyBotApiAuthHeader    = @{ "authorization"="Bearer $($Token.access_token)" }
        }
        catch{
            Write-Error -Message "$_ went wrong."
        }
    }
    End{
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}