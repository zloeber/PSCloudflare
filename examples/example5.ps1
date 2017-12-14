Import-Module PSCloudFlare
$Token = '<your token here>'
$Email = 'it@domain.com'
$Zone = 'domain.com'

# Connect to the CloudFlare Client API
try {
    Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
}
catch {
    throw $_
}

# Retrieve all records in the zone
Set-CFCurrentZone -Zone $Zone -Verbose
Get-CFDNSRecord