#Requires -Modules SPSImmyBot

<#
.SYNOPSIS
    Generates a comprehensive Windows version report for all computers in ImmyBot
.DESCRIPTION
    This script uses the SPSImmyBot module to collect Windows version information
    from all computers and generates a detailed report with computer names, domains,
    Windows versions, build numbers, and last check-in times.
.PARAMETER OutputPath
    Path where the CSV report will be saved. Defaults to current directory.
.PARAMETER ExcludeOffline
    Exclude computers that haven't checked in recently
.PARAMETER DaysBack
    Only include computers that have checked in within this many days (default: 30)
.EXAMPLE
    .\Get-WindowsVersionReport.ps1
    Generates a report for all computers and saves to WindowsVersionReport.csv
.EXAMPLE
    .\Get-WindowsVersionReport.ps1 -OutputPath "C:\Reports\" -DaysBack 7
    Generates a report for computers active in last 7 days
#>

[CmdletBinding()]
param(
    [string]$OutputPath = ".\WindowsVersionReport.csv",
    [switch]$ExcludeOffline,
    [int]$DaysBack = 0
)

Write-Host "Starting Windows Version Report Generation..." -ForegroundColor Green

# Step 1: Get all computers
Write-Host "Retrieving all computers from ImmyBot..." -ForegroundColor Yellow
try {
    $allComputers = Get-ImmyComputerDetails -All -Take 10000 -IncludeOffline:(!$ExcludeOffline)
      # Debug information
    Write-Host "Raw response type: $($allComputers.GetType().Name)" -ForegroundColor Gray
    Write-Host "Available properties: $($allComputers.PSObject.Properties.Name -join ', ')" -ForegroundColor Gray
    
    # Handle different response formats (ImmyBot API returns lowercase properties)
    if ($allComputers.PSObject.Properties.Name -contains 'count') {
        Write-Host "Found $($allComputers.count) total computers" -ForegroundColor Green
        $totalCount = $allComputers.count
    } elseif ($allComputers.PSObject.Properties.Name -contains 'TotalCount') {
        Write-Host "Found $($allComputers.TotalCount) total computers" -ForegroundColor Green
        $totalCount = $allComputers.TotalCount
    } else {
        $totalCount = 0
    }
    
    if ($allComputers.PSObject.Properties.Name -contains 'results') {
        Write-Host "Results array contains $($allComputers.results.Count) computers" -ForegroundColor Green
        $computerResults = $allComputers.results
    } elseif ($allComputers.PSObject.Properties.Name -contains 'Results') {
        Write-Host "Results array contains $($allComputers.Results.Count) computers" -ForegroundColor Green
        $computerResults = $allComputers.Results
    } else {
        Write-Host "No results property found. Treating response as direct array." -ForegroundColor Yellow
        $computerResults = $allComputers
        $totalCount = $allComputers.Count
    }
    
    # Normalize the response structure
    $allComputers = [PSCustomObject]@{
        Results = $computerResults
        TotalCount = $totalCount
    }
}
catch {
    Write-Error "Failed to retrieve computers: $_"
    exit 1
}

# Step 2: Filter by date if specified
if ($DaysBack -gt 0) {
    $cutoffDate = (Get-Date).AddDays(-$DaysBack)
    $filteredComputers = $allComputers.Results | Where-Object {
        $_.lastSeen -and [DateTime]$_.lastSeen -gt $cutoffDate
    }
    Write-Host "Filtered to $($filteredComputers.Count) computers active in last $DaysBack days" -ForegroundColor Green
} else {
    $filteredComputers = $allComputers.Results
    Write-Host "Processing all $($filteredComputers.Count) computers (no date filtering)" -ForegroundColor Green
}

# Check if we have any computers to process
if ($filteredComputers.Count -eq 0) {
    Write-Warning "No computers found to process. Check your ImmyBot connection and permissions."
    Write-Host "Debug: AllComputers.Results count: $($allComputers.Results.Count)" -ForegroundColor Gray
    Write-Host "Debug: DaysBack setting: $DaysBack" -ForegroundColor Gray
    if ($DaysBack -gt 0) {
        Write-Host "Debug: Cutoff date: $cutoffDate" -ForegroundColor Gray
        Write-Host "Try running with -DaysBack 0 to include all computers regardless of last seen date." -ForegroundColor Yellow
    }
    exit 1
}

# Step 3: Get inventory data for all computers
Write-Host "Retrieving inventory data..." -ForegroundColor Yellow
try {
    $inventoryData = Get-ImmyInventoryData
    Write-Host "Retrieved inventory data for analysis" -ForegroundColor Green
}
catch {
    Write-Warning "Could not retrieve bulk inventory data, will try individual computer queries"
    $inventoryData = $null
}

# Step 4: Process each computer and extract Windows version info
Write-Host "Processing computer data and extracting Windows versions..." -ForegroundColor Yellow
$report = @()
$counter = 0

foreach ($computer in $filteredComputers) {
    $counter++
    Write-Progress -Activity "Processing Computers" -Status "Processing $($computer.name)" -PercentComplete (($counter / $filteredComputers.Count) * 100)    # Initialize report object
    $computerReport = [PSCustomObject]@{
        ComputerId = $computer.Id
        ComputerName = $computer.name  # Correct property name
        Domain = $null
        WindowsVersion = $null
        WindowsBuild = $null
        Architecture = $null
        LastSeen = $computer.lastSeen
        Status = $null
        TenantName = $computer.tenantName
        PrimaryUser = $null
    }
      # Try to get Windows version from inventory data
    $windowsInfo = $null
    
    if ($inventoryData) {        # Look for this computer in the bulk inventory data
        $computerInventory = $inventoryData | Where-Object { 
            $_.ComputerId -eq $computer.Id -or $_.ComputerName -eq $computer.name 
        }
        
        if ($computerInventory -and $computerInventory.WindowsSystemInfo) {
            $windowsInfo = $computerInventory.WindowsSystemInfo
        }
    }
    
    # If not found in bulk data, try individual computer query
    if (-not $windowsInfo) {
        try {
            # Get detailed computer info which includes inventory
            $detailedComputer = Get-ImmyComputerDetails -ComputerId $computer.Id
            if ($detailedComputer.inventory.WindowsSystemInfo.Output) {
                $windowsInfo = $detailedComputer.inventory.WindowsSystemInfo.Output
            }
              # Get primary user if available
            if ($detailedComputer.primaryPerson -and $detailedComputer.primaryPerson.DisplayName) {
                $computerReport.PrimaryUser = $detailedComputer.primaryPerson.DisplayName
            }
        }        catch {
            Write-Warning "Could not get detailed info for computer $($computer.name): $_"
        }
    }
      # Extract Windows version information
    if ($windowsInfo) {
        $computerReport.WindowsVersion = $windowsInfo.OsName
        $computerReport.WindowsBuild = $windowsInfo.Version
        $computerReport.Architecture = $windowsInfo.Architecture
        
        # Try to extract domain from WindowsSystemInfo if not already set
        if (-not $computerReport.Domain -and $windowsInfo.Domain) {
            $computerReport.Domain = $windowsInfo.Domain
        }
          # Use the actual computer name from Windows system info if available and different
        if ($windowsInfo.ComputerName) {
            $computerReport.ComputerName = $windowsInfo.ComputerName
        }
    }
      # Try to determine status
    if ($computer.lastSeen) {
        $lastSeenDate = [DateTime]$computer.lastSeen
        $daysSinceLastSeen = ((Get-Date) - $lastSeenDate).Days
        
        if ($daysSinceLastSeen -le 1) {
            $computerReport.Status = "Online"
        } elseif ($daysSinceLastSeen -le 7) {
            $computerReport.Status = "Recent"
        } else {
            $computerReport.Status = "Stale"
        }
    } else {
        $computerReport.Status = "Unknown"
    }
    
    $report += $computerReport
}

Write-Progress -Activity "Processing Computers" -Completed

# Step 5: Generate summary statistics
Write-Host "`nGenerating summary statistics..." -ForegroundColor Yellow

$totalComputers = $report.Count
$computersWithVersion = ($report | Where-Object { $_.WindowsVersion }).Count
$uniqueVersions = $report | Where-Object { $_.WindowsVersion } | Group-Object WindowsVersion | Sort-Object Count -Descending

Write-Host "`n=== WINDOWS VERSION REPORT SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total Computers Processed: $totalComputers" -ForegroundColor White
Write-Host "Computers with Version Data: $computersWithVersion" -ForegroundColor White

# Fix division by zero error
if ($totalComputers -gt 0) {
    $coveragePercentage = [math]::Round(($computersWithVersion / $totalComputers) * 100, 1)
    Write-Host "Coverage: $coveragePercentage%" -ForegroundColor White
} else {
    Write-Host "Coverage: 0% (No computers processed)" -ForegroundColor Red
}

Write-Host "`nWindows Version Distribution:" -ForegroundColor Yellow
if ($computersWithVersion -gt 0) {
    foreach ($version in $uniqueVersions) {
        $percentage = [math]::Round(($version.Count / $computersWithVersion) * 100, 1)
        Write-Host "  $($version.Name): $($version.Count) computers ($percentage%)" -ForegroundColor White
    }
} else {
    Write-Host "  No Windows version data found" -ForegroundColor Red
}

# Step 6: Export to CSV
Write-Host "`nExporting report to $OutputPath..." -ForegroundColor Yellow
try {
    $report | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Report successfully exported to: $OutputPath" -ForegroundColor Green
}
catch {
    Write-Error "Failed to export report: $_"
    exit 1
}

# Step 7: Display sample of results
Write-Host "`nSample of results (first 10 computers):" -ForegroundColor Yellow
$report | Select-Object -First 10 | Format-Table ComputerName, Domain, WindowsVersion, WindowsBuild, Status, LastSeen -AutoSize

Write-Host "`nReport generation complete!" -ForegroundColor Green
Write-Host "Full report saved to: $OutputPath" -ForegroundColor Cyan
