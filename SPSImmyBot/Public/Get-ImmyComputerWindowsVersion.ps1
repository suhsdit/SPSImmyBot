Function Get-ImmyComputerWindowsVersion {
<#
.SYNOPSIS
    Gets Windows version information for a computer from ImmyBot
.DESCRIPTION
    Extracts Windows version, build number, and architecture information from the WindowsSystemInfo inventory data
.EXAMPLE
    Get-ImmyComputerWindowsVersion -ComputerId 6658
    Gets Windows version information for computer with ID 6658
.EXAMPLE
    Get-ImmyComputerWindowsVersion -ComputerId 6658 -Detailed
    Gets detailed Windows system information including additional fields
.PARAMETER ComputerId
    The ID of the computer to get Windows version information for
.PARAMETER Detailed
    Include additional system information like manufacturer, model, domain, etc.
.INPUTS
    None
.OUTPUTS
    PSCustomObject containing Windows version information
.NOTES
    Requires SPSImmyBot module and valid authentication
    Uses WindowsSystemInfo inventory data from ImmyBot
.LINK
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]$ComputerId,
        
        [switch]$Detailed
    )
    
    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName)..."
    }
    
    Process {
        try {
            Write-Verbose "Getting Windows version information for computer ID: $ComputerId"
            
            # Get computer details with inventory
            $computer = Get-ImmyComputerDetails -ComputerId $ComputerId
            
            if (-not $computer) {
                throw "Computer with ID $ComputerId not found"
            }
            
            # Extract Windows system info
            $windowsInfo = $computer.inventory.WindowsSystemInfo.Output
            
            if (-not $windowsInfo) {
                throw "WindowsSystemInfo inventory data not available for computer $ComputerId"
            }
            
            # Create basic version object
            $versionInfo = [PSCustomObject]@{
                ComputerId = $ComputerId
                ComputerName = $computer.computerName
                OsName = $windowsInfo.OsName
                Version = $windowsInfo.Version
                Architecture = $windowsInfo.Architecture
                LastBootTime = $windowsInfo.LastBootTime
                OsInstallDate = $windowsInfo.OsInstallDate
            }
            
            # Add detailed information if requested
            if ($Detailed) {
                $versionInfo | Add-Member -NotePropertyName 'Manufacturer' -NotePropertyValue $windowsInfo.Manufacturer
                $versionInfo | Add-Member -NotePropertyName 'Model' -NotePropertyValue $windowsInfo.Model
                $versionInfo | Add-Member -NotePropertyName 'SerialNumber' -NotePropertyValue $windowsInfo.SerialNumber
                $versionInfo | Add-Member -NotePropertyName 'Domain' -NotePropertyValue $windowsInfo.Domain
                $versionInfo | Add-Member -NotePropertyName 'CPU' -NotePropertyValue $windowsInfo.CPU
                $versionInfo | Add-Member -NotePropertyName 'CPUCount' -NotePropertyValue $windowsInfo.CPUCount
                $versionInfo | Add-Member -NotePropertyName 'TimeZone' -NotePropertyValue $windowsInfo.TimeZone
                $versionInfo | Add-Member -NotePropertyName 'TPMVersion' -NotePropertyValue $windowsInfo.TPMVersion
                $versionInfo | Add-Member -NotePropertyName 'HyperVHost' -NotePropertyValue $windowsInfo.HyperVHost
                $versionInfo | Add-Member -NotePropertyName 'PSVersion' -NotePropertyValue $windowsInfo.PSVersion
            }
            
            return $versionInfo
        }
        catch {
            Write-Error -Message "Failed to get Windows version information for computer $ComputerId`: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
