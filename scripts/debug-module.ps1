#!/usr/bin/env pwsh

Write-Host "Starting module debug..."

try {
    Write-Host "1. Importing module..."
    Import-Module "c:\Users\jgeron\VSCode\SPSImmyBot-1\SPSImmyBot\SPSImmyBot.psd1" -Force -Verbose
    
    Write-Host "2. Checking if module loaded..."
    $module = Get-Module SPSImmyBot
    if ($module) {
        Write-Host "Module loaded successfully: $($module.Name) version $($module.Version)"
    } else {
        Write-Host "Module not loaded!"
        exit 1
    }
    
    Write-Host "3. Listing all functions in module..."
    $functions = Get-Command -Module SPSImmyBot -CommandType Function
    Write-Host "Found $($functions.Count) functions:"
    $functions | Format-Table Name, CommandType
    
    Write-Host "4. Testing Get-ImmyComputer function..."
    $cmd = Get-Command Get-ImmyComputer -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "Get-ImmyComputer found: $($cmd.Name)"
    } else {
        Write-Host "Get-ImmyComputer NOT found"
    }
    
    Write-Host "5. Testing Get-IBComputer alias..."
    $alias = Get-Alias Get-IBComputer -ErrorAction SilentlyContinue
    if ($alias) {
        Write-Host "Get-IBComputer alias found: $($alias.Name) -> $($alias.Definition)"
    } else {
        Write-Host "Get-IBComputer alias NOT found"
    }
    
} catch {
    Write-Error "Error during module loading: $_"
}
