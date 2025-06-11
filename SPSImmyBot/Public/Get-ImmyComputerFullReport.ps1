Function Get-ImmyComputerFullReport {
<#
.SYNOPSIS
    Gets a comprehensive report for a computer including all available details
.DESCRIPTION
    This function retrieves all available information for a specific computer,
    including basic details, software, status, and inventory data. This provides
    a complete picture of the computer's state and configuration.
.EXAMPLE
    Get-ImmyComputerFullReport -ComputerId 8
    Gets a full report for computer with ID 8
.EXAMPLE
    Get-ImmyComputerFullReport -ComputerId 8 -InventoryKeys @("Hardware", "Software")
    Gets a full report including specific inventory data
.PARAMETER ComputerId
    The ID of the computer to generate a report for
.PARAMETER InventoryKeys
    Array of inventory keys to include in the report (optional)
.PARAMETER SkipInventory
    Skip inventory data collection (faster execution)
.INPUTS
    None
.OUTPUTS
    PSCustomObject containing comprehensive computer information
.NOTES
    Requires SPSImmyBot module and valid authentication
    This function combines multiple API calls for comprehensive reporting
.LINK
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$ComputerId,
        
        [string[]]$InventoryKeys,
        
        [switch]$SkipInventory
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) for computer ID: $ComputerId"
    }
    
    Process {
        try {
            $report = [PSCustomObject]@{
                ComputerId = $ComputerId
                Timestamp = Get-Date
                BasicDetails = $null
                DetectedSoftware = $null
                Status = $null
                InventoryData = @{}
                Errors = @()
            }
            
            # Get basic computer details with all available options
            Write-Verbose "Retrieving basic computer details..."
            try {
                $report.BasicDetails = Get-ImmyComputerDetails -ComputerId $ComputerId -IncludeSoftware -IncludeSessions -IncludeProviderAgents
            }
            catch {
                $report.Errors += "Basic Details: $_"
                Write-Warning "Could not retrieve basic details: $_"
            }
            
            # Get computer status
            Write-Verbose "Retrieving computer status..."
            try {
                $report.Status = Get-ImmyComputerStatus -ComputerId $ComputerId
            }
            catch {
                $report.Errors += "Status: $_"
                Write-Warning "Could not retrieve status: $_"
            }
            
            # Get inventory data if requested
            if (-not $SkipInventory -and $InventoryKeys) {
                Write-Verbose "Retrieving inventory data for keys: $($InventoryKeys -join ', ')"
                foreach ($key in $InventoryKeys) {
                    try {
                        $inventoryData = Get-ImmyComputerInventory -ComputerId $ComputerId -InventoryKey $key
                        $report.InventoryData[$key] = $inventoryData
                    }
                    catch {
                        $report.Errors += "Inventory ($key): $_"
                        Write-Warning "Could not retrieve inventory data for key '$key': $_"
                    }
                }
            }
            
            Write-Verbose "Computer report completed with $($report.Errors.Count) errors"
            return $report
        }
        catch {
            Write-Error -Message "Failed to generate computer report for ID $ComputerId`: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
