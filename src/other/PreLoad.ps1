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

# Some enumerations that will allow us to do validateset-like operations and include $null values
Enum CFFirewallTarget {
    ip
    ip_range
    country
    asn
}

Enum CFFirewallMode {
    whitelist
    block
    challenge
    js_challenge
}