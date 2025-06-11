Function New-SPSImmyBotWindowsConfiguration {
<#
.SYNOPSIS
    Setup new configuration to use for the SPSImmyBot Module
.DESCRIPTION
    Setup new configuration to use for the SPSImmyBot Module
.EXAMPLE
    New-SPSImmyBotConfiguration
    Start the process of setting config. Follow prompts.
.PARAMETER
.INPUTS
.OUTPUTS
.NOTES
.LINK
#>
    [CmdletBinding()] #Enable all the default paramters, including -Verbose
    Param(
        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [String]$Name
    )

    Begin{
        Write-Verbose -Message "Starting $($MyInvocation.InvocationName) with $($PsCmdlet.ParameterSetName) parameterset..."
        Write-Verbose -Message "Parameters are $($PSBoundParameters | Select-Object -Property *)"
    }
    Process{
        # If no users are specified, get all students
        try{
            if (!$Name) {
                $Name = Read-Host "Config Name"
            }

            if(!(Test-Path -path "$SPSImmyBotConfigRoot\$Name")) {
                New-Item -ItemType Directory -Name $Name -Path $Script:SPSImmyBotConfigRoot
                $Script:SPSImmyBotConfigDir = "$Script:SPSImmyBotConfigRoot\$Name"

                Write-Verbose -Message "Setting new Config file"

                $AzureDomain = Read-Host "Your Azure domain"
                $ImmyBotSubdomain = Read-Host "Your ImmyBot Sub-domain"

                Write-Output "###### INSTRUCTIONS ######"
                Write-Output "Create a brand new App Registration in Azure Active Directory, leave it completely unmodified, don’t change any defaults."
                Write-Output "Copy the Client (Application) ID into the prompt below"
                $ClientID = Read-Host "Your ClientID"

                Write-Output "Create a secret under Certificates and Secrets and copy the secret VALUE (NOT THE ID!) into the prompt below"
                Get-Credential -UserName ' ' -Message "Your Secret Value" | Export-Clixml "$SPSImmyBotConfigDir\secret.xml"

                Write-Output "Navigate to the Enterprise App that was created in your Azure AD."
                Write-Output "(You can do this by clicking the Managed Application link on the bottom right of the App Registration)"
                Write-Output "Copy the object id into the AD External ID field into a new Person in Immy"
                Write-Output "Make that person a user then make the user an admin."

                @{Config=$Name;AzureDomain=$AzureDomain;ImmyBotSubdomain=$ImmyBotSubdomain;ClientID=$ClientID} |
                    ConvertTo-Json | Out-File "$SPSImmyBotConfigDir\config.json"

                # Set the new files as active
                Set-SPSImmyBotWindowsConfiguration $Name
            }
            else {
                Write-Warning -Message "Config already exists."
                break
            }
        }
        catch{
            Write-Error -Message "$_ went wrong."
        }
    }
    End{
        Write-Verbose -Message "Ending $($MyInvocation.InvocationName)..."
    }
}