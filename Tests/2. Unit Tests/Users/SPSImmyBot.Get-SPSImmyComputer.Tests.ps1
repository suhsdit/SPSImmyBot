# Module loading and setup
$module = "SPSImmyBot"

# Remove any existing module
Remove-Module SPSImmyBot -Force -ErrorAction SilentlyContinue

# Use absolute path to the module
$moduleDirectory = "c:\Users\jgeron\VSCode\SPSImmyBot-1\SPSImmyBot"
Import-Module "$moduleDirectory\$module.psd1" -Force -Global

# Set script variables in the SPSImmyBot module scope
& (Get-Module SPSImmyBot) {
    $Script:BaseURL = "https://test.immy.bot"
    $Script:ImmyBotApiAuthHeader = @{ "Authorization" = "Bearer fake-token" }
}

# Mock Invoke-ImmyAPI to avoid actual API calls
Mock Invoke-ImmyAPI -ModuleName SPSImmyBot -MockWith {
    param($Endpoint, $Method)
    
    if ($Endpoint -like "computers/paged*") {
        return @{
            results = @(
                @{ id = 1; name = "Computer1"; computerId = 1 }
                @{ id = 2; name = "Computer2"; computerId = 2 }
                }
    elseif ($Endpoint -like "computers/*") {
        return @{
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

Describe -Tags ('Unit') "Get-IBComputer Tests" {
    
    Context 'Parameter Validation' {
        It "Should accept valid First parameter" {
            $Command = Get-Command Get-IBComputer
            $ValidateRange = $Command.Parameters['First'].Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $ValidateRange.MinRange | Should -Be 1
            $ValidateRange.MaxRange | Should -Be 10000
        }
        
        It "Should reject First parameter outside valid range" {
            { Get-IBComputer -First 0 } | Should -Throw
            { Get-IBComputer -First 50000 } | Should -Throw
        }
          It "Should accept all boolean parameters" {
            $Command = Get-Command Get-IBComputer
            $Command.Parameters['OnboardingOnly'].ParameterType | Should -Be ([bool])
            $Command.Parameters['StaleOnly'].ParameterType | Should -Be ([bool])
            $Command.Parameters['IncludeOffline'].ParameterType | Should -Be ([bool])
        }
          It "Should accept TenantId parameter" {
            $Command = Get-Command Get-IBComputer
            $Command.Parameters['TenantId'].ParameterType | Should -Be ([int])
        }
    }
    
    Context 'Function Structure' {
        
        It "Should have proper CmdletBinding" {
            $Command = Get-Command Get-IBComputer
            $Command.CmdletBinding | Should -Be $true
        }
        
        It "Should support common parameters" {
            $Command = Get-Command Get-IBComputer
            $Command.Parameters.ContainsKey('Verbose') | Should -Be $true
            $Command.Parameters.ContainsKey('Debug') | Should -Be $true
        }
    }
}

Describe -Tags ('Unit') "Get-IBComputerDetail Tests" {
    
    Context 'Parameter Validation' {
        
        It "Should require ComputerId parameter" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters['ComputerId'].Attributes.Mandatory | Should -Contain $true
        }
        
        It "Should accept ComputerId from pipeline" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters['ComputerId'].Attributes.ValueFromPipeline | Should -Contain $true
        }
        
        It "Should accept ComputerId from pipeline by property name" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters['ComputerId'].Attributes.ValueFromPipelineByPropertyName | Should -Contain $true
        }
        
        It "Should have Id alias for ComputerId" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters['ComputerId'].Aliases | Should -Contain 'Id'
        }
          It "Should accept all boolean parameters" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters['IncludeSessions'].ParameterType | Should -Be ([bool])
            $Command.Parameters['IncludeProviderAgents'].ParameterType | Should -Be ([bool])
        }
    }
    
    Context 'Function Structure' {
        
        It "Should have proper CmdletBinding" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.CmdletBinding | Should -Be $true
        }
        
        It "Should support pipeline processing" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters['ComputerId'].Attributes.ValueFromPipeline | Should -Contain $true
        }
        
        It "Should support common parameters" {
            $Command = Get-Command Get-IBComputerDetail
            $Command.Parameters.ContainsKey('Verbose') | Should -Be $true
            $Command.Parameters.ContainsKey('Debug') | Should -Be $true
        }
    }
}

Describe -Tags ('Unit') "Computer Functions Integration" {
    
    Context 'Pipeline Compatibility' {
        
        It "Should have compatible pipeline properties between Get-IBComputer and Get-IBComputerDetail" {
            $GetComputerCommand = Get-Command Get-IBComputer
            $GetDetailCommand = Get-Command Get-IBComputerDetail
            
            # Get-IBComputerDetail should accept ComputerId from pipeline by property name
            $GetDetailCommand.Parameters['ComputerId'].Attributes.ValueFromPipelineByPropertyName | Should -Contain $true
        }
    }
    
    Context 'Function Naming and Structure' {
        
        It "Should follow PowerShell naming conventions" {
            $GetComputerCommand = Get-Command Get-IBComputer
            $GetDetailCommand = Get-Command Get-IBComputerDetail
            
            $GetComputerCommand.Verb | Should -Be 'Get'
            $GetDetailCommand.Verb | Should -Be 'Get'
            
            $GetComputerCommand.Noun | Should -Be 'IBComputer'
            $GetDetailCommand.Noun | Should -Be 'IBComputerDetail'
        }
    }
}

Describe -Tags ('Unit') "Get-ImmyComputer Tests" {
    
    Context 'Parameter Validation' {
        It "Should accept valid First parameter" {
            $Command = Get-Command Get-ImmyComputer
            $ValidateRange = $Command.Parameters['First'].Attributes | Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] }
            $ValidateRange.MinRange | Should -Be 1
            $ValidateRange.MaxRange | Should -Be 100
        }
        
        It "Should have correct parameter types" {
            $Command = Get-Command Get-ImmyComputer
            $Command.Parameters['Filter'].ParameterType | Should -Be ([string])
            $Command.Parameters['Skip'].ParameterType | Should -Be ([int])
            $Command.Parameters['First'].ParameterType | Should -Be ([int])
        }
        
        It "Should have switch parameters as SwitchParameter type" {
            $Command = Get-Command Get-ImmyComputer
            $Command.Parameters['OnboardingOnly'].ParameterType | Should -Be ([switch])
            $Command.Parameters['StaleOnly'].ParameterType | Should -Be ([switch])
            $Command.Parameters['SortDescending'].ParameterType | Should -Be ([switch])
        }
    }
    
    Context 'Function Structure' {
        
        It "Should have proper CmdletBinding" {
            $Command = Get-Command Get-ImmyComputer
            $Command.CmdletBinding | Should -Be $true
        }
        
        It "Should support common parameters" {
            $Command = Get-Command Get-ImmyComputer
            $Command.Parameters.ContainsKey('Verbose') | Should -Be $true
            $Command.Parameters.ContainsKey('Debug') | Should -Be $true
        }
          It "Should use Invoke-ImmyAPI internally" {
            # This test ensures the function uses the centralized API function
            Get-ImmyComputer -First 1 | Out-Null
            Should -Invoke Invoke-ImmyAPI -ModuleName SPSImmyBot -Exactly 1
        }
    }
}

Describe -Tags ('Unit') "Get-ImmyComputerDetail Tests" {
    
    Context 'Parameter Validation' {
        
        It "Should require ComputerId parameter" {
            $Command = Get-Command Get-ImmyComputerDetail
            $Command.Parameters['ComputerId'].Attributes.Mandatory | Should -Contain $true
        }
        
        It "Should have Id alias for ComputerId" {
            $Command = Get-Command Get-ImmyComputerDetail
            $Command.Parameters['ComputerId'].Aliases | Should -Contain 'Id'
        }
        
        It "Should accept all boolean parameters" {
            $Command = Get-Command Get-ImmyComputerDetail
            $Command.Parameters['IncludeSessions'].ParameterType | Should -Be ([bool])
            $Command.Parameters['IncludeProviderAgents'].ParameterType | Should -Be ([bool])
        }
    }
    
    Context 'Function Structure' {
        
        It "Should have proper CmdletBinding" {
            $Command = Get-Command Get-ImmyComputerDetail
            $Command.CmdletBinding | Should -Be $true
        }
        
        It "Should support pipeline processing" {
            $Command = Get-Command Get-ImmyComputerDetail
            $Command.Parameters['ComputerId'].Attributes.ValueFromPipeline | Should -Contain $true
        }
        
        It "Should support common parameters" {
            $Command = Get-Command Get-ImmyComputerDetail
            $Command.Parameters.ContainsKey('Verbose') | Should -Be $true
            $Command.Parameters.ContainsKey('Debug') | Should -Be $true
        }
          It "Should use Invoke-ImmyAPI internally" {
            # This test ensures the function uses the centralized API function
            Get-ImmyComputerDetail -ComputerId 123 | Out-Null
            Should -Invoke Invoke-ImmyAPI -ModuleName SPSImmyBot -Exactly 1
        }
    }
}

Describe -Tags ('Unit') "Backward Compatibility and Aliases" {
    
    Context 'Alias Functionality' {
        
        It "Should have Get-IBComputer alias pointing to Get-ImmyComputer" {
            $Alias = Get-Alias Get-IBComputer -ErrorAction SilentlyContinue
            $Alias | Should -Not -BeNullOrEmpty
            $Alias.ReferencedCommand.Name | Should -Be 'Get-ImmyComputer'
        }
        
        It "Should have Get-IBComputerDetail alias pointing to Get-ImmyComputerDetail" {
            $Alias = Get-Alias Get-IBComputerDetail -ErrorAction SilentlyContinue
            $Alias | Should -Not -BeNullOrEmpty
            $Alias.ReferencedCommand.Name | Should -Be 'Get-ImmyComputerDetail'
        }
        
        It "Should have Get-IBDevices alias pointing to Get-ImmyComputer" {
            $Alias = Get-Alias Get-IBDevices -ErrorAction SilentlyContinue
            $Alias | Should -Not -BeNullOrEmpty
            $Alias.ReferencedCommand.Name | Should -Be 'Get-ImmyComputer'
        }
        
        It "Should have Get-IBDevice alias pointing to Get-ImmyComputer" {
            $Alias = Get-Alias Get-IBDevice -ErrorAction SilentlyContinue
            $Alias | Should -Not -BeNullOrEmpty
            $Alias.ReferencedCommand.Name | Should -Be 'Get-ImmyComputer'
        }
    }
    
    Context 'Functional Compatibility' {
        
        It "Should work identically when called via alias vs direct function name" {
            $DirectResult = Get-ImmyComputer -First 1
            $AliasResult = Get-IBComputer -First 1
            
            $DirectResult.Count | Should -Be $AliasResult.Count
            $DirectResult[0].id | Should -Be $AliasResult[0].id
        }
    }
}

Describe -Tags ('Unit') "Immy Functions Integration" {
    
    Context 'Pipeline Compatibility' {
          It "Should have compatible pipeline properties between Get-ImmyComputer and Get-ImmyComputerDetail" {
            $GetDetailCommand = Get-Command Get-ImmyComputerDetail
            
            # Get-ImmyComputerDetail should accept ComputerId from pipeline by property name
            $GetDetailCommand.Parameters['ComputerId'].Attributes.ValueFromPipelineByPropertyName | Should -Contain $true
        }
        
        It "Should support cross-function pipeline operations" {
            # This test verifies that the output of Get-ImmyComputer can be piped to Get-ImmyComputerDetail
            $Result = Get-ImmyComputer -First 1 | Get-ImmyComputerDetail
            $Result | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-ImmyAPI -ModuleName SPSImmyBot -Exactly 2
        }
    }
    
    Context 'Function Naming and Structure' {
        
        It "Should follow PowerShell naming conventions" {
            $GetComputerCommand = Get-Command Get-ImmyComputer
            $GetDetailCommand = Get-Command Get-ImmyComputerDetail
            
            $GetComputerCommand.Verb | Should -Be 'Get'
            $GetDetailCommand.Verb | Should -Be 'Get'
            
            $GetComputerCommand.Noun | Should -Be 'ImmyComputer'
            $GetDetailCommand.Noun | Should -Be 'ImmyComputerDetail'
        }
        
        It "Should use singular nouns" {
            $GetComputerCommand = Get-Command Get-ImmyComputer
            $GetComputerCommand.Noun | Should -Be 'ImmyComputer'  # Not 'ImmyComputers'
        }
    }
}