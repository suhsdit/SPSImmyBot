Function Get-ImmyInventoryData {
<#
.SYNOPSIS
    Gets inventory data from all computers
.DESCRIPTION
    This function retrieves inventory data from all computers using the inventory endpoint.
    This provides a consolidated view of inventory across all computers.
.EXAMPLE
    Get-ImmyInventoryData
    Gets all inventory data
.EXAMPLE
    $inventory = Get-ImmyInventoryData
    $inventory | Where-Object {$_.ComputerName -like "*SERVER*"}
    Gets inventory data and filters for servers
.INPUTS
    None
.OUTPUTS
    Array of inventory objects
.NOTES
    Requires SPSImmyBot module and valid authentication
    Based on ImmyBot API v1 endpoint: /api/v1/computers/inventory
.LINK
#>
    [CmdletBinding()]
    param()

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName)..."
    }
    
    Process {
        try {
            $endpoint = "computers/inventory"
            Write-Verbose "Retrieving all inventory data using endpoint: $endpoint"
            
            $result = Invoke-ImmyApi -Endpoint $endpoint
            return $result
        }
        catch {
            Write-Error -Message "Failed to retrieve inventory data: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
