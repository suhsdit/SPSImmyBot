#region: Mock a config and load it for other functions to use
Mock 'Set-SPSImmyBotConfiguration' -ModuleName SPSImmyBot -MockWith {
    Write-Verbose "Getting mocked SPSImmyBot config"
    $script:SPSImmyBot = [PSCustomObject][Ordered]@{
        ConfigName = 'Pester'
        APIKey = ([System.IO.Path]::Combine($PSScriptRoot,"fake_api_key.xml"))
        APIURL = 'https://prefix.domain.com/api/v3/'
    }
}
Set-SPSImmyBotConfiguration -Verbose
#endregion

