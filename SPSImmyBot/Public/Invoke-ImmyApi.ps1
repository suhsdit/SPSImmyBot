Function Invoke-ImmyApi {
<#
.SYNOPSIS
    Invokes a general API request for data to be queried from your ImmyBot domain
.DESCRIPTION
    The Invoke-ImmyAPI function can access any data from your ImmyBot domain
    *REQUIRED PARAMS* - tbd
.EXAMPLE
    Invoke-ImmyAPI tbd
.PARAMETER
.INPUTS
.OUTPUTS
.NOTES
.LINK
#>
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    param(
        [string]$Endpoint,
    
        [string]$Method,
    
        $Body
    )

    Begin{
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
        $Endpoint = $Endpoint.TrimStart('/')
        $params = @{}
        if($Method) {
            $params.method = $Method
        }
        if($Body) {
            $params.body = $body
        }
    }
    Process{
        Invoke-RestMethod -Uri "$($Script:BaseURL)/api/v1/$Endpoint" -Headers $Script:ImmyBotApiAuthHeader @params
    }
    End{
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}