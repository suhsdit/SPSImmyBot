# Simple test to verify Pester functionality
Remove-Module SPSImmyBot -Force -ErrorAction SilentlyContinue
Import-Module "c:\Users\jgeron\VSCode\SPSImmyBot-1\SPSImmyBot\SPSImmyBot.psd1" -Force -Global

Describe "Simple Module Test" {
    It "Should load Get-ImmyComputer function" {
        Get-Command Get-ImmyComputer | Should -Not -BeNullOrEmpty
    }
    
    It "Should load Get-ImmyComputerDetail function" {
        Get-Command Get-ImmyComputerDetail | Should -Not -BeNullOrEmpty
    }
}
