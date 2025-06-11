Function Get-ImmyComputerDetail {
<#
.SYNOPSIS
    Gets detailed information about a specific computer from ImmyBot
.DESCRIPTION
    The Get-ImmyComputerDetail function retrieves comprehensive information about a single computer
    from your ImmyBot domain. This provides much more detailed information than Get-ImmyComputer.
.EXAMPLE
    Get-ImmyComputerDetail -ComputerId 123
    Gets detailed information for computer with ID 123
.EXAMPLE
    Get-ImmyComputer -Filter "LAPTOP-001" | Get-ImmyComputerDetail
    Gets detailed information for computers matching filter, passed through pipeline
.EXAMPLE
    Get-ImmyComputerDetail -ComputerId 123 -IncludeSessions -IncludeProviderAgents
    Gets detailed computer information including session data and provider agents
.PARAMETER ComputerId
    The ID of the computer to retrieve detailed information for
.PARAMETER IncludeSessions
    Include session information in the response (default: false)
.PARAMETER IncludeAdditionalPersons
    Include additional persons associated with the computer (default: true)
.PARAMETER IncludePrimaryPerson
    Include primary person associated with the computer (default: true)
.PARAMETER IncludeProviderAgents
    Include provider agent information (default: false)
.PARAMETER IncludeProviderAgentsDeviceUpdateFormData
    Include provider agent device update form data (default: false)
.INPUTS
    Int32 - Computer ID from pipeline
    PSObject - Computer object with ComputerId property from pipeline
.OUTPUTS
    GetComputerResponse - Detailed computer information object
.NOTES
    This function uses the /api/v1/computers/{computerId} endpoint which provides comprehensive computer details.
    For listing multiple computers with basic information, use Get-ImmyComputer.
    
    Backward compatibility: This function replaces Get-IBComputerDetail.
.LINK
    Get-ImmyComputer
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias('Id')]
        [int]$ComputerId,
        
        [Parameter(Mandatory=$false)]
        [bool]$IncludeSessions = $false,
        
        [Parameter(Mandatory=$false)]
        [bool]$IncludeAdditionalPersons = $true,
        
        [Parameter(Mandatory=$false)]
        [bool]$IncludePrimaryPerson = $true,
        
        [Parameter(Mandatory=$false)]
        [bool]$IncludeProviderAgents = $false,
        
        [Parameter(Mandatory=$false)]
        [bool]$IncludeProviderAgentsDeviceUpdateFormData = $false
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
    }
    
    Process {
        Write-Verbose -Message "Processing computer ID: $ComputerId"
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
        
        try {
            # Build the endpoint URL with query parameters
            $QueryParams = @()
            
            $QueryParams += "includeSessions=$($IncludeSessions.ToString().ToLower())"
            $QueryParams += "includeAdditionalPersons=$($IncludeAdditionalPersons.ToString().ToLower())"
            $QueryParams += "includePrimaryPerson=$($IncludePrimaryPerson.ToString().ToLower())"
            $QueryParams += "includeProviderAgents=$($IncludeProviderAgents.ToString().ToLower())"
            $QueryParams += "includeProviderAgentsDeviceUpdateFormData=$($IncludeProviderAgentsDeviceUpdateFormData.ToString().ToLower())"
            
            $QueryString = $QueryParams -join '&'
            $Endpoint = "computers/${ComputerId}?${QueryString}"
            
            Write-Verbose -Message "Final Endpoint: $Endpoint"
              # Use Invoke-ImmyApi for consistent API calling
            $Response = Invoke-ImmyApi -Endpoint $Endpoint -Method GET
            
            # Add type information for better object handling
            $Response.PSObject.TypeNames.Insert(0, 'ImmyBot.ComputerDetail')
            
            Write-Verbose -Message "Retrieved detailed information for computer: $($Response.name) (ID: $ComputerId)"
            return $Response
        }
        catch {
            if ($_.Exception.Response.StatusCode -eq 404) {
                Write-Error "Computer with ID $ComputerId not found."
            }
            else {
                Write-Error "Failed to retrieve computer details for ID $ComputerId`: $_"
            }
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
