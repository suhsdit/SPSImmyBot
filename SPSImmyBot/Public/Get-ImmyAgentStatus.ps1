Function Get-ImmyAgentStatus {
<#
.SYNOPSIS
    Gets the agent status for all computers
.DESCRIPTION
    This function retrieves the agent status information for all computers,
    showing connectivity and agent health across the environment.
.EXAMPLE
    Get-ImmyAgentStatus
    Gets agent status for all computers
.EXAMPLE
    Get-ImmyAgentStatus | Where-Object {$_.Status -eq "Offline"}
    Gets only computers with offline agents
.INPUTS
    None
.OUTPUTS
    Array of agent status objects
.NOTES
    Requires SPSImmyBot module and valid authentication
    Based on ImmyBot API v1 endpoint: /api/v1/computers/agent-status
.LINK
#>
    [CmdletBinding()]
    param()

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName)..."
    }
    
    Process {
        try {
            $endpoint = "computers/agent-status"
            Write-Verbose "Retrieving agent status using endpoint: $endpoint"
            
            $result = Invoke-ImmyApi -Endpoint $endpoint
            return $result
        }
        catch {
            Write-Error -Message "Failed to retrieve agent status: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
