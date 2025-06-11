Function Get-ImmyBotApiAuthToken
{
    Param ($TenantId,$ApplicationId,$Secret,$ApiEndpointUri)
    $RequestAccessTokenUri = "https://login.microsoftonline.com/$($tenantID)/oauth2/token"
    $body ="grant_type=client_credentials&client_id=$($ClientID)&client_secret=$($Secret)&resource=$($apiEndpointUri)"
    $contentType = 'application/x-www-form-urlencoded'
   try
    {
        $Token = Invoke-RestMethod -Method Post -Uri $RequestAccessTokenUri -Body $body -ContentType $contentType -verbose
        return $Token
    }
    catch { throw }
}