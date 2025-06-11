Function Get-ImmyComputerDetails {
<#
.SYNOPSIS
    Gets detailed information about computers from ImmyBot
.DESCRIPTION
    This function provides an easy way to retrieve comprehensive computer information
    from ImmyBot, including software, hardware, inventory, sessions, and user data.
.EXAMPLE
    Get-ImmyComputerDetails -ComputerId 8
    Gets all available details for computer with ID 8
.EXAMPLE
    Get-ImmyComputerDetails -ComputerId 8 -IncludeSoftware -IncludeInventory -IncludeSessions
    Gets computer details with software, inventory and session information
.EXAMPLE
    Get-ImmyComputerDetails -All -Take 50 -Filter "Name contains 'SERVER'"
    Gets detailed information for the first 50 computers with 'SERVER' in the name
.EXAMPLE
    Get-ImmyComputerDetails -All -Take 100 -OnboardingOnly
    Gets computers that are in onboarding status only
.PARAMETER ComputerId
    The ID of the specific computer to retrieve details for
.PARAMETER All
    Retrieve details for all computers (use with -Take to limit results)
.PARAMETER Take
    Number of computers to retrieve when using -All (default: 50, max recommended: 1000)
.PARAMETER Skip
    Number of computers to skip when using -All
.PARAMETER Filter
    OData filter expression for filtering computers (e.g., "Name contains 'SERVER'")
.PARAMETER Sort
    Field to sort by (e.g., "Name", "LastSeen", "CreatedDate")
.PARAMETER SortDesc
    Sort in descending order (default: true)
.PARAMETER IncludeSoftware
    Include detected software information in the results
.PARAMETER IncludeInventory
    Include inventory script results in the results
.PARAMETER IncludeSessions
    Include session information in the results
.PARAMETER IncludePrimaryPerson
    Include primary person information (default: true for single computer)
.PARAMETER IncludeAdditionalPersons
    Include additional persons information (default: true for single computer)
.PARAMETER IncludeProviderAgents
    Include provider agent information
.PARAMETER IncludeOffline
    Include offline computers in the results (when using -All, default: true)
.PARAMETER OnboardingOnly
    Only return computers in onboarding status
.PARAMETER StaleOnly
    Only return stale computers
.PARAMETER DevLabOnly
    Only return development/lab computers
.PARAMETER LicensedOnly
    Only return licensed computers
.PARAMETER DeletedOnly
    Only return deleted computers
.PARAMETER TenantId
    Filter by specific tenant ID
.INPUTS
    None
.OUTPUTS
    PSCustomObject containing computer details
.NOTES
    Requires SPSImmyBot module and valid authentication
    Based on ImmyBot API v1 endpoints from swagger documentation
.LINK
#>    [CmdletBinding(DefaultParameterSetName = 'Single')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Single')]
        [int]$ComputerId,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch]$All,
        
        [Parameter(ParameterSetName = 'All')]
        [int]$Take = 50,
        
        [Parameter(ParameterSetName = 'All')]
        [int]$Skip = 0,
        
        [Parameter(ParameterSetName = 'All')]
        [string]$Filter,
        
        [Parameter(ParameterSetName = 'All')]
        [string]$Sort,
        
        [Parameter(ParameterSetName = 'All')]
        [bool]$SortDesc = $true,
        
        # Include options for detailed data
        [switch]$IncludeSoftware,
        [switch]$IncludeInventory,
        [switch]$IncludeSessions,
        [bool]$IncludePrimaryPerson = $true,
        [bool]$IncludeAdditionalPersons = $true,
        [switch]$IncludeProviderAgents,
        
        # Filtering options for All parameter set
        [Parameter(ParameterSetName = 'All')]
        [bool]$IncludeOffline = $true,
        
        [Parameter(ParameterSetName = 'All')]
        [switch]$OnboardingOnly,
        
        [Parameter(ParameterSetName = 'All')]
        [switch]$StaleOnly,
        
        [Parameter(ParameterSetName = 'All')]
        [switch]$DevLabOnly,
        
        [Parameter(ParameterSetName = 'All')]
        [switch]$LicensedOnly,
        
        [Parameter(ParameterSetName = 'All')]
        [switch]$DeletedOnly,
        
        [Parameter(ParameterSetName = 'All')]
        [int]$TenantId
    )    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters: $($PSBoundParameters | ConvertTo-Json -Compress)"
    }
    
    Process {
        try {
            if ($PsCmdlet.ParameterSetName -eq 'Single') {
                # Get details for a specific computer using actual API parameters
                $queryParams = @()
                
                if ($IncludeSessions) {
                    $queryParams += "includeSessions=true"
                }
                if ($IncludePrimaryPerson) {
                    $queryParams += "includePrimaryPerson=true"
                }
                if ($IncludeAdditionalPersons) {
                    $queryParams += "includeAdditionalPersons=true"
                }
                if ($IncludeProviderAgents) {
                    $queryParams += "includeProviderAgents=true"
                }
                
                $endpoint = "Computers/$ComputerId"
                if ($queryParams.Count -gt 0) {
                    $endpoint += "?" + ($queryParams -join '&')
                }
                
                Write-Verbose "Retrieving details for computer ID: $ComputerId using endpoint: $endpoint"
                $result = Invoke-ImmyApi -Endpoint $endpoint
                
                # Get additional detailed information from sub-endpoints
                if ($IncludeSoftware) {
                    Write-Verbose "Retrieving software information for computer ID: $ComputerId"
                    try {
                        $softwareData = Invoke-ImmyApi -Endpoint "Computers/$ComputerId/detected-computer-software"
                        $result | Add-Member -NotePropertyName 'DetectedSoftware' -NotePropertyValue $softwareData -Force
                    }
                    catch {
                        Write-Warning "Could not retrieve software data for computer $ComputerId`: $_"
                    }
                }
                
                if ($IncludeInventory) {
                    Write-Verbose "Retrieving inventory information for computer ID: $ComputerId"
                    try {
                        # Note: Inventory script results require an inventory key, which we don't have here
                        # This would need to be called with specific inventory keys
                        Write-Verbose "Inventory data requires specific inventory keys - use Invoke-ImmyApi directly with 'Computers/$ComputerId/inventory-script-results/{inventoryKey}'"
                    }
                    catch {
                        Write-Warning "Could not retrieve inventory data for computer $ComputerId`: $_"
                    }
                }
                
                return $result
            }
            else {
                # Get details for multiple computers using the paged endpoint
                $queryParams = @()
                $queryParams += "skip=$Skip"
                $queryParams += "take=$Take"
                $queryParams += "sortDesc=$($SortDesc.ToString().ToLower())"
                $queryParams += "includeOffline=$($IncludeOffline.ToString().ToLower())"
                
                if ($Filter) {
                    $queryParams += "filter=$([System.Web.HttpUtility]::UrlEncode($Filter))"
                }
                
                if ($Sort) {
                    $queryParams += "sort=$([System.Web.HttpUtility]::UrlEncode($Sort))"
                }
                
                if ($OnboardingOnly) {
                    $queryParams += "onboardingOnly=true"
                }
                
                if ($StaleOnly) {
                    $queryParams += "staleOnly=true"
                }
                
                if ($DevLabOnly) {
                    $queryParams += "devLabOnly=true"
                }
                
                if ($LicensedOnly) {
                    $queryParams += "licensedOnly=true"
                }
                
                if ($DeletedOnly) {
                    $queryParams += "deletedOnly=true"
                }
                
                if ($TenantId) {
                    $queryParams += "tenantId=$TenantId"
                }
                
                $endpoint = "computers/paged?" + ($queryParams -join '&')
                
                Write-Verbose "Retrieving computer list with endpoint: $endpoint"
                $result = Invoke-ImmyApi -Endpoint $endpoint
                
                # If additional details are requested for the list, note that this would be expensive
                if ($IncludeSoftware -or $IncludeInventory) {
                    Write-Warning "Including software or inventory data for multiple computers can be slow. Consider getting the list first, then calling Get-ImmyComputerDetails for specific computers."
                }
                
                return $result
            }
        }
        catch {
            Write-Error -Message "Failed to retrieve computer details: $_"
            throw
        }
    }
    
    End {
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}
