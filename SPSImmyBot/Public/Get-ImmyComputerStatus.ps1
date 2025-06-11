Function Get-ImmyComputerStatus {
<#
.SYNOPSIS
    Gets the current status of a specific computer
.DESCRIPTION
    This function retrieves the current status information for a specific computer,
    including connectivity, agent status, and other operational details.
.EXAMPLE
    Get-ImmyComputerStatus -ComputerId 8
    Gets the status for computer with ID 8
.PARAMETER ComputerId
    The ID of the computer to retrieve status for
.INPUTS
    None
.OUTPUTS
    PSCustomObject containing computer status information
.NOTES
    Requires SPSImmyBot module and valid authentication
    Based on ImmyBot API v1 endpoint: /api/v1/computers/{computerId}/status
.LINK
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]$ComputerId
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName)..."
    }
    
    Process {
        try {
            $endpoint = "computers/$ComputerId/status"
            Write-Verbose "Retrieving status for computer ID: $ComputerId using endpoint: $endpoint"
            
            $result = Invoke-ImmyApi -Endpoint $endpoint
            return $result
        }
        catch {
            Write-Error -Message "Failed to retrieve status for computer $ComputerId`: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
