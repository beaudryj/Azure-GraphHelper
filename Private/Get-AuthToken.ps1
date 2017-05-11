function Get-AuthToken {
[cmdletBinding()]
Param (
$redirectUri,
$clientId,
$clientSecret,
$authCode,
$resource
)

$body = "grant_type=authorization_code&redirect_uri=$redirectUri&client_id=$clientId&client_secret=$clientSecretEncoded&code=$authCode&resource=$resource"
$Authorization = Invoke-RestMethod https://login.microsoftonline.com/common/oauth2/token `
    -Method Post -ContentType "application/x-www-form-urlencoded" `
    -Body $body `
    -ErrorAction STOP

return $accesstoken = $Authorization.access_token

}
