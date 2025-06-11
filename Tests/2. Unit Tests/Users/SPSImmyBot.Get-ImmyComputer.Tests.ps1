# Simple tests for Get-ImmyComputer function

$module = "SPSImmyBot"

# Remove any existing module
Remove-Module SPSImmyBot -Force -ErrorAction SilentlyContinue

# Import the module
$moduleDirectory = "c:\Users\jgeron\VSCode\SPSImmyBot-1\SPSImmyBot"
Import-Module "$moduleDirectory\$module.psd1" -Force -Global

# Set up mock authentication
& (Get-Module SPSImmyBot) {
    $Script:BaseURL = "https://test.immy.bot"
    $Script:ImmyBotApiAuthHeader = @{ "Authorization" = "Bearer fake-token" }
}

# Mock Invoke-ImmyApi to avoid actual API calls
Mock Invoke-ImmyApi -ModuleName SPSImmyBot -MockWith {
    param($Endpoint, $Method)
    
    if ($Endpoint -like "computers/paged*") {
        # Return a proper PSCustomObject array
        $computers = @()
        $computers += [PSCustomObject]@{ id = 1; name = "Computer1"; computerId = 1 }
        $computers += [PSCustomObject]@{ id = 2; name = "Computer2"; computerId = 2 }
        $computers += [PSCustomObject]@{ id = 3; name = "Computer3"; computerId = 3 }
        
        return [PSCustomObject]@{
            results = $computers
        }
    }
    elseif ($Endpoint -like "computers/*") {
        return [PSCustomObject]@{
            id = 123
            name = "TestComputer"
            computerId = 123
            domain = "test.local"
        }
    }
    else {
        throw "Unexpected API call to: $Endpoint"
    }
}

Describe -Tags ('Unit') "Get-ImmyComputer Basic Tests" {
    
    It "Should return computers when called without parameters" {
        $result = Get-ImmyComputer
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 3
    }

    It "Should accept and use First parameter" {
        $result = Get-ImmyComputer -First 2
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be 2
    }

    It "Should accept Filter parameter" {
        { Get-ImmyComputer -Filter "TestComputer" } | Should -Not -Throw
    }

    It "Should accept switch parameters" {
        { Get-ImmyComputer -OnboardingOnly } | Should -Not -Throw
        { Get-ImmyComputer -LicensedOnly } | Should -Not -Throw
    }

    It "Should return objects with expected properties" {
        $result = Get-ImmyComputer
        $result[0].PSObject.Properties.Name | Should -Contain "id"
        $result[0].PSObject.Properties.Name | Should -Contain "name"
        $result[0].PSObject.Properties.Name | Should -Contain "computerId"
    }
}

Describe -Tags ('Unit') "Get-ImmyComputerDetail Basic Tests" {
    
    It "Should accept ComputerId parameter" {
        $result = Get-ImmyComputerDetail -ComputerId 123
        $result | Should -Not -BeNullOrEmpty
        $result.id | Should -Be 123
    }

    It "Should return object with expected properties" {
        $result = Get-ImmyComputerDetail -ComputerId 123
        $result.PSObject.Properties.Name | Should -Contain "id"
        $result.PSObject.Properties.Name | Should -Contain "name"
        $result.PSObject.Properties.Name | Should -Contain "domain"
    }
}