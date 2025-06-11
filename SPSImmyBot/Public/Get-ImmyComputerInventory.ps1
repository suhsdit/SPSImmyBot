Function Get-ImmyComputerInventory {
<#
.SYNOPSIS
    Gets inventory script results for a specific computer
.DESCRIPTION
    This function retrieves inventory script results for a specific computer using
    an inventory key. Use Get-ImmyInventoryKeys to discover available inventory keys.
.EXAMPLE
    Get-ImmyComputerInventory -ComputerId 8 -InventoryKey "Hardware"
    Gets hardware inventory data for computer with ID 8
.EXAMPLE
    Get-ImmyComputerInventory -ComputerId 8 -InventoryKey "Software"
    Gets software inventory data for computer with ID 8
.PARAMETER ComputerId
    The ID of the computer to retrieve inventory for
.PARAMETER InventoryKey
    The inventory key/script name to retrieve results for
.INPUTS
    None
.OUTPUTS
    PSCustomObject containing inventory results
.NOTES
    Requires SPSImmyBot module and valid authentication
    Based on ImmyBot API v1 endpoint: /api/v1/computers/{computerId}/inventory-script-results/{inventoryKey}
.LINK
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$ComputerId,
        
        [Parameter(Mandatory = $true)]
        [string]$InventoryKey
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName)..."
        Write-Verbose -Message "ComputerId: $ComputerId, InventoryKey: $InventoryKey"
    }
    
    Process {
        try {
            $endpoint = "computers/$ComputerId/inventory-script-results/$InventoryKey"
            Write-Verbose "Retrieving inventory data using endpoint: $endpoint"
            
            $result = Invoke-ImmyApi -Endpoint $endpoint
            return $result
        }
        catch {
            Write-Error -Message "Failed to retrieve inventory data for computer $ComputerId with key '$InventoryKey': $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
