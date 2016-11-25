# Used to determine if we are connected to anything
$Script:Headers = $null

# Used to always have a recent set of parameters used to invoke a REST method
$Script:RESTParams = @{
    'Uri' = $null
    'Headers' = $null
    'Body' = @{}
    'Method' = 'Get'
}

# Used for keeping track of the current zone
$Script:ZoneID = $null
$Script:ZoneName = $null

# Just in case the URI changes in the future
$Script:APIURI = 'https://api.cloudflare.com/client/v4'