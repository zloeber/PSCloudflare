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

# Get all records for this zone
Get-CFDNSRecord

# Get a single record
Get-CFDNSRecord -ID 'b67f86cfeac112a63f6a816371b168fc'
