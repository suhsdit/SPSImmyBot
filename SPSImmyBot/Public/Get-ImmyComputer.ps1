Function Get-ImmyComputer {
<#
.SYNOPSIS
    Gets computer information from ImmyBot
.DESCRIPTION
    The Get-ImmyComputer function retrieves computer information from your ImmyBot domain.
    This function provides comprehensive filtering options for retrieving computers,
    and supports pipeline operations.
.EXAMPLE
    Get-ImmyComputer
    Gets all computers from ImmyBot
.EXAMPLE
    Get-ImmyComputer -Filter "LAPTOP-001"
    Gets computers matching the filter "LAPTOP-001"
.EXAMPLE
    Get-ImmyComputer -OnboardingOnly
    Gets computers that are in onboarding status
.EXAMPLE
    Get-ImmyComputer -TenantId 123 -LicensedOnly
    Gets only licensed computers from tenant ID 123
.EXAMPLE
    Get-ImmyComputer -First 10
    Gets the first 10 computers from ImmyBot
.PARAMETER Filter
    Filter computers by name or other searchable fields
.PARAMETER Sort
    Field to sort by (e.g., "name", "lastSeen", "operatingSystem")
.PARAMETER SortDescending
    Sort in descending order (default: false)
.PARAMETER OnboardingOnly
    Return only computers in onboarding status
.PARAMETER StaleOnly
    Return only stale computers
.PARAMETER DevLabOnly
    Return only dev/lab computers
.PARAMETER IncludeOffline
    Include offline computers in results
.PARAMETER LicensedOnly
    Return only licensed computers
.PARAMETER DeletedOnly
    Return only deleted computers
.PARAMETER TenantId
    Filter by specific tenant ID
.PARAMETER First
    Limit the number of computers returned (1-1000)
.INPUTS
    None
.OUTPUTS
    Computer[] - Array of computer objects
.NOTES
    This function uses the /api/v1/computers/paged endpoint to retrieve all computers.
    For detailed information about a specific computer, use Get-ImmyComputerDetail.
    
    Backward compatibility: This function replaces Get-IBComputer and Get-IBDevices.
.LINK
    Get-ImmyComputerDetail
#>    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Filter,
        
        [Parameter(Mandatory=$false)]
        [string]$Sort,
        
        [Parameter(Mandatory=$false)]
        [switch]$SortDescending,
        
        [Parameter(Mandatory=$false)]
        [switch]$OnboardingOnly,
        
        [Parameter(Mandatory=$false)]
        [switch]$StaleOnly,
        
        [Parameter(Mandatory=$false)]
        [switch]$DevLabOnly,
        
        [Parameter(Mandatory=$false)]
        [switch]$IncludeOffline,
        
        [Parameter(Mandatory=$false)]
        [switch]$LicensedOnly,
          [Parameter(Mandatory=$false)]
        [switch]$DeletedOnly,
        
        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 10000)]
        [int]$First = 10000,
        
        [Parameter(Mandatory=$false)]
        [int]$TenantId
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
    }
    
    Process {
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
        
        try {            # Build query parameters
            $QueryParams = @()
            
            if ($PSBoundParameters.ContainsKey('Filter') -and $Filter) {
                $QueryParams += "filter=$([System.Uri]::EscapeDataString($Filter))"
            }
            
            if ($PSBoundParameters.ContainsKey('Sort') -and $Sort) {
                $QueryParams += "sort=$([System.Uri]::EscapeDataString($Sort))"
            }
            
            if ($SortDescending) {
                $QueryParams += "sortDescending=true"
            }
            
            if ($OnboardingOnly) {
                $QueryParams += "onboardingOnly=true"
            }
            
            if ($StaleOnly) {
                $QueryParams += "staleOnly=true"
            }
            
            if ($DevLabOnly) {
                $QueryParams += "devLabOnly=true"
            }
            
            if ($IncludeOffline) {
                $QueryParams += "includeOffline=true"
            }
            
            if ($LicensedOnly) {
                $QueryParams += "licensedOnly=true"
            }
            
            if ($DeletedOnly) {
                $QueryParams += "deletedOnly=true"
            }              if ($PSBoundParameters.ContainsKey('TenantId')) {
                $QueryParams += "tenantId=$TenantId"
            }
            
            # Always include the take parameter (uses default value of 10000 if not specified)
            $QueryParams += "take=$First"
            
            # Build endpoint with query parameters
            $QueryString = $QueryParams -join '&'
            $Endpoint = "computers/paged?$QueryString"
            
            Write-Verbose -Message "Final Endpoint: $Endpoint"
              # Use Invoke-ImmyApi for consistent API calling
            $Response = Invoke-ImmyApi -Endpoint $Endpoint -Method GET            # Extract and return the computers
            if ($Response -and $Response.results) {
                $Computers = $Response.results
                
                # Apply client-side First limit if needed (in case API doesn't honor limit parameter)
                if ($PSBoundParameters.ContainsKey('First') -and $Computers.Count -gt $First) {
                    $Computers = $Computers | Select-Object -First $First
                }
                
                # Add type information for better object handling
                foreach ($Computer in $Computers) {
                    $Computer.PSObject.TypeNames.Insert(0, 'ImmyBot.Computer')
                }
                
                Write-Verbose -Message "Retrieved $($Computers.Count) computers"
                return $Computers
            }
            else {
                Write-Verbose -Message "No computers found matching the specified criteria"
                return @()
            }
        }
        catch {
            Write-Error "Failed to retrieve computers: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
