Import-Module PSCloudFlare
$Token = '<your API token>'
$Email = 'itops@contoso.com'
$Zone = 'contoso.com'

# Connect to the CloudFlare Client API
try {
    Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
}
catch {
    throw $_
}

# Retrieve all records in the zone
Set-CFCurrentZone -Zone $Zone -Verbose

# Purge stale URLs
$URLs = @(
    "https://contoso.com/stale/link/01"
    "https://contoso.com/stale/link/02"
    "https://contoso.com/stale/link/03"
)
Purge-CFFile -Urls $URLs