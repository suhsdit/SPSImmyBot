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
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [String]$Endpoint,
    
        [Parameter(Mandatory=$false,
            Position=1)]
        [String]$Method,
    
        [Parameter(Mandatory=$false,
            Position=2)]
        [Object]$Body
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