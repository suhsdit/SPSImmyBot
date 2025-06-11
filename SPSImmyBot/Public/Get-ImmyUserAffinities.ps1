Function Get-ImmyUserAffinities {
<#
.SYNOPSIS
    Gets user affinity data for computers
.DESCRIPTION
    This function retrieves user affinity information, showing which users
    are associated with which computers based on usage patterns.
.EXAMPLE
    Get-ImmyUserAffinities
    Gets all user affinity data
.EXAMPLE
    $affinities = Get-ImmyUserAffinities
    $affinities | Where-Object {$_.UserName -like "*john*"}
    Gets user affinities for users with "john" in their name
.INPUTS
    None
.OUTPUTS
    Array of user affinity objects
.NOTES
    Requires SPSImmyBot module and valid authentication
    Based on ImmyBot API v1 endpoint: /api/v1/computers/user-affinities
.LINK
#>
    [CmdletBinding()]
    param()

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName)..."
    }
    
    Process {
        try {
            $endpoint = "computers/user-affinities"
            Write-Verbose "Retrieving user affinities using endpoint: $endpoint"
            
            $result = Invoke-ImmyApi -Endpoint $endpoint
            return $result
        }
        catch {
            Write-Error -Message "Failed to retrieve user affinities: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
