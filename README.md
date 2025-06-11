# SPSImmyBot PowerShell Module

A PowerShell module for interacting with the ImmyBot API to retrieve computer information, inventory data, and perform management tasks.

## Features

- **Computer Information Retrieval**: Get comprehensive computer data from your ImmyBot instance
- **Detailed Computer Views**: Access detailed computer information including inventory, sessions, and agent data
- **Flexible Filtering**: Filter computers by various criteria (tenant, status, licensing, etc.)
- **Pipeline Support**: Seamlessly pipe computer objects between functions
- **Robust API Integration**: Built-in authentication, error handling, and verbose logging

## Available Functions

| Function | Description |
|----------|-------------|
| `Get-ImmyComputer` | Retrieve computer information with filtering options |
| `Get-ImmyComputerDetail` | Get detailed information for a specific computer |
| `Invoke-ImmyApi` | Core API function for making authenticated requests |
| `Set-SPSImmyBotWindowsConfiguration` | Configure authentication for your ImmyBot instance |
| `New-SPSImmyBotWindowsConfiguration` | Create new authentication configuration |
| `Get-ImmyBotApiAuthToken` | Retrieve authentication token |

## Quick Start

### 1. Install and Import the Module

```powershell
# Import the module
Import-Module .\SPSImmyBot\SPSImmyBot.psd1

# Configure authentication (replace 'your-config-name' with your setup)
Set-SPSImmyBotWindowsConfiguration -Name "your-config-name"
```

### 2. Basic Usage Examples

```powershell
# Get all computers (limited to first 10 for performance)
Get-ImmyComputer -First 10

# Get computers from a specific tenant
Get-ImmyComputer -TenantId 123 -First 5

# Filter computers by name
Get-ImmyComputer -Filter "LAPTOP-001"

# Get only licensed computers
Get-ImmyComputer -LicensedOnly -First 20

# Get detailed information for a specific computer
Get-ImmyComputerDetail -ComputerId 456

# Pipeline example: Get computer details for filtered results
Get-ImmyComputer -Filter "SERVER" -First 3 | Get-ImmyComputerDetail
```

### 3. Advanced Filtering

```powershell
# Get computers in onboarding status
Get-ImmyComputer -OnboardingOnly

# Get stale computers with offline included
Get-ImmyComputer -StaleOnly -IncludeOffline

# Get dev/lab computers only
Get-ImmyComputer -DevLabOnly

# Get deleted computers (for cleanup/audit)
Get-ImmyComputer -DeletedOnly

# Sort computers by last seen date
Get-ImmyComputer -Sort "lastSeen" -SortDescending -First 15
```

## Configuration Setup

### Prerequisites

1. **ImmyBot Instance**: You need access to an ImmyBot instance
2. **API Authentication**: Set up API authentication (Azure AD App Registration recommended)
3. **PowerShell 5.1+**: Module requires PowerShell 5.1 or later

### Authentication Configuration

The module supports configuration-based authentication using Azure AD App Registration. Follow these detailed steps:

#### Step 1: Create Azure AD App Registration

1. **Navigate to Azure Portal**:
   - Go to [Azure Portal](https://portal.azure.com)
   - Navigate to "Azure Active Directory" > "App registrations"

2. **Create New App Registration**:
   - Click "New registration"
   - **Name**: Enter a descriptive name (e.g., "ImmyBot API Access")
   - **Supported account types**: Select "Accounts in this organizational directory only"
   - **Redirect URI**: Leave blank
   - Click "Register"

3. **Copy Application (Client) ID**:
   - On the Overview page, copy the **Application (client) ID**
   - Save this value - you'll need it for configuration

4. **Create Client Secret**:
   - Navigate to "Certificates & secrets" in the left menu
   - Click "New client secret"
   - **Description**: Enter "ImmyBot API Secret"
   - **Expires**: Choose appropriate expiration (recommended: 24 months)
   - Click "Add"
   - **IMPORTANT**: Copy the secret **Value** (not the ID!) immediately - you cannot view it again

#### Step 2: Configure ImmyBot User

1. **Get Enterprise Application Object ID**:
   - In your App Registration, click the "Managed application in local directory" link
   - On the Enterprise Application page, copy the **Object ID**

2. **Create Person in ImmyBot**:
   - Log into your ImmyBot instance
   - Navigate to "People"
   - Create a new Person
   - In the **AD External ID** field, paste the Object ID from step 1
   - Save the person

3. **Configure User Permissions**:
   - Make the person a User in ImmyBot
   - Grant the user Admin permissions for API access

#### Step 3: Configure the PowerShell Module

1. **Create Configuration**:
   ```powershell
   # This will prompt you for all required values
   New-SPSImmyBotWindowsConfiguration -Name "production"
   ```

   **You will be prompted for**:
   - **Config Name**: A name for this configuration (e.g., "production", "staging")
   - **Azure Domain**: Your Azure AD domain (e.g., "contoso.com")
   - **ImmyBot Subdomain**: Your ImmyBot subdomain (e.g., "contoso" for contoso.immy.bot)
   - **Client ID**: The Application (client) ID from Step 1.3
   - **Secret Value**: The client secret value from Step 1.4 (enter as password when prompted)

2. **Activate Configuration**:
   ```powershell
   Set-SPSImmyBotWindowsConfiguration -Name "production"
   ```

3. **Verify Configuration**:
   ```powershell
   # Test with a simple API call
   Get-ImmyComputer -First 1 -Verbose
   ```

#### Alternative: Manual Configuration

If you prefer to configure manually without prompts:

```powershell
Set-SPSImmyBotConfiguration -Name "production" -AzureDomain "contoso.com" -ImmyBotSubdomain "contoso" -ClientID "your-client-id" -Secret "your-secret-value"
```

#### Troubleshooting Authentication

Common issues and solutions:

- **401 Unauthorized**: Check that the Enterprise App Object ID is correctly entered in ImmyBot Person's AD External ID field
- **403 Forbidden**: Ensure the Person in ImmyBot has User and Admin permissions
- **Invalid Client**: Verify the Client ID and Secret are correct
- **Token Endpoint Issues**: Confirm the Azure Domain is correct (should match your Azure AD tenant)

## Function Reference

### Get-ImmyComputer

Retrieves computer information with comprehensive filtering options.

**Parameters:**
- `Filter` - Filter computers by name or searchable fields
- `First` - Limit the number of results (1-1000, recommended for performance)
- `Sort` - Field to sort by (e.g., "name", "lastSeen", "operatingSystem")
- `SortDescending` - Sort in descending order
- `OnboardingOnly` - Return only computers in onboarding status
- `StaleOnly` - Return only stale computers
- `DevLabOnly` - Return only dev/lab computers
- `IncludeOffline` - Include offline computers in results
- `LicensedOnly` - Return only licensed computers
- `DeletedOnly` - Return only deleted computers
- `TenantId` - Filter by specific tenant ID

**Returns:** Array of computer objects with ImmyBot.Computer type

### Get-ImmyComputerDetail

Retrieves detailed information about a specific computer.

**Parameters:**
- `ComputerId` - The ID of the computer (required)
- `IncludeSessions` - Include session information (default: false)
- `IncludeAdditionalPersons` - Include additional persons (default: true)
- `IncludePrimaryPerson` - Include primary person (default: true)
- `IncludeProviderAgents` - Include provider agent information (default: false)
- `IncludeProviderAgentsDeviceUpdateFormData` - Include device update form data (default: false)

**Returns:** Detailed computer object with ImmyBot.ComputerDetail type

## Best Practices

1. **Use -First Parameter**: Always limit results to avoid retrieving thousands of computers
   ```powershell
   # Good
   Get-ImmyComputer -First 50
   
   # Avoid (may return all computers)
   Get-ImmyComputer
   ```

2. **Use Verbose Logging**: Enable verbose output for troubleshooting
   ```powershell
   Get-ImmyComputer -First 5 -Verbose
   ```

3. **Pipeline Operations**: Leverage PowerShell pipelines for efficient data processing
   ```powershell
   Get-ImmyComputer -TenantId 123 -First 10 | 
       Get-ImmyComputerDetail | 
       Where-Object { $_.isOnline -eq $true } |
       Select-Object computerName, tenantName, lastBootTimeUtc
   ```

4. **Error Handling**: Use try-catch blocks for production scripts
   ```powershell
   try {
       $computers = Get-ImmyComputer -First 10
       Write-Host "Retrieved $($computers.Count) computers"
   }
   catch {
       Write-Error "Failed to retrieve computers: $_"
   }
   ```

## Testing

The module includes comprehensive tests:

```powershell
# Run unit tests
Invoke-Pester ".\Tests\2. Unit Tests\Users\SPSImmyBot.Get-ImmyComputer.Tests.ps1"

# Run all tests
Invoke-Pester ".\Tests\" -Recurse
```

## Module Architecture

- **Consistent API Calls**: All functions use `Invoke-ImmyApi` for standardized error handling
- **Type Safety**: Objects are typed as `ImmyBot.Computer` and `ImmyBot.ComputerDetail`
- **Pipeline Support**: Functions support ValueFromPipeline and ValueFromPipelineByPropertyName
- **Verbose Logging**: Comprehensive logging for troubleshooting and debugging
- **Configuration Management**: Centralized authentication and configuration handling

## Changelog

### Version 2.0
- **✅ COMPLETED**: Removed legacy IB-prefixed functions
- **✅ COMPLETED**: Implemented Immy-prefixed functions (`Get-ImmyComputer`, `Get-ImmyComputerDetail`)
- **✅ COMPLETED**: Fixed API response structure handling (`results` vs `items`)
- **✅ COMPLETED**: Added practical `-First` parameter for result limiting
- **✅ COMPLETED**: Implemented comprehensive pipeline support
- **✅ COMPLETED**: Fixed function naming consistency (`Invoke-ImmyApi`)
- **✅ COMPLETED**: Added comprehensive test coverage
- **✅ COMPLETED**: Centralized API calls through `Invoke-ImmyApi`

## Contributing

Please see the [AI Guide.md](AI%20Guide.md) for development best practices and lessons learned from module development.

### Development Setup

1. Clone the repository
2. Import the module: `Import-Module .\SPSImmyBot\SPSImmyBot.psd1`
3. Run tests: `Invoke-Pester .\Tests\ -Recurse`
4. Review the AI Guide for development patterns and gotchas

## License

This project is licensed under the MIT License.

## Support

For issues or questions:
1. Check the verbose output: `Get-ImmyComputer -Verbose`
2. Review the [AI Guide.md](AI%20Guide.md) for common issues
3. Check API connectivity and authentication configuration
