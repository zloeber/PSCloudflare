# Used to determine if we are connected to anything
$Script:Headers = $null

# Used for keeping track of the current zone
$Script:ZoneID = $null
$Script:ZoneName = $null

# Just in case the URI changes in the future
$Script:APIURI = 'https://api.cloudflare.com/client/v4'