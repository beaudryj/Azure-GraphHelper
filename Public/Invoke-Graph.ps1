function Invoke-Graph {
    [cmdletBinding()]
    Param(
        $resource = "https://graph.microsoft.com",
        $apiVersion = "v1.0",
        [Parameter(Mandatory=$true)]
        [PSCredential]$ClientCredential,
        $redirectUri = "http://localhost/",
        $method,
        $requestedResource
    )

    Add-Type -AssemblyName System.Web

    $clientId = $ClientCredential.UserName
    $clientIDEncoded = [System.Web.HttpUtility]::UrlEncode($ClientCredential.UserName)
    $clientSecretEncoded = [System.Web.HttpUtility]::UrlEncode($ClientCredential.GetNetworkCredential().Password)
    $redirectUriEncoded =  [System.Web.HttpUtility]::UrlEncode($redirectUri)
    $resourceEncoded = [System.Web.HttpUtility]::UrlEncode($resource)

    $url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&redirect_uri=$redirectUriEncoded&client_id=$clientID&resource=$resourceEncoded"
    Get-AuthCode -url $url

    $regex = '(?<=code=)(.*)(?=&)'
    $authCode  = ($uri | Select-string -pattern $regex).Matches[0].Value

    $accessToken = Get-AuthToken -redirectUri $redirectUri `
                    -clientId $clientId `
                    -clientSecret $ClientCredential.GetNetworkCredential().Password `
                    -AuthCode $authCode `
                    -Resource $resource `


    $request = Invoke-RestMethod -Headers @{Authorization = "Bearer $accesstoken"} `
                        -Uri  "$resource/$apiVersion/$requestedResource" `
                        -Method $Method
    
    return $request
}