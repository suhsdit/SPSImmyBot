Describe "Simple Module Test" {
    BeforeAll {
        # Remove any existing module
        Remove-Module SPSImmyBot -Force -ErrorAction SilentlyContinue
        
        # Use absolute path to the module
        $moduleDirectory = "c:\Users\jgeron\VSCode\SPSImmyBot-1\SPSImmyBot"
        Import-Module "$moduleDirectory\SPSImmyBot.psd1" -Force -Global
    }
    
    Context "Module Loading" {
        It "Should load Get-ImmyComputer function" {
            $Command = Get-Command Get-ImmyComputer -ErrorAction SilentlyContinue
            $Command | Should -Not -BeNullOrEmpty
            $Command.Name | Should -Be 'Get-ImmyComputer'
        }
        
        It "Should load Get-IBComputer alias" {
            $Alias = Get-Alias Get-IBComputer -ErrorAction SilentlyContinue
            $Alias | Should -Not -BeNullOrEmpty
            $Alias.Name | Should -Be 'Get-IBComputer'
        }
    }
}
