# Removes all whitelisted firewall rules. (Using -Whatif just to validate though, not actually removing)
Import-Module .\PSCloudflare.psm1
$Token = 'aaaaaaaaaabbbbbbbbbbccccccccccc1234552'
$Email = 'jdoe@contoso.com'
$Zone = 'contoso.com'

Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
Set-CFCurrentZone -Zone $Zone
Get-CFFirewallRule -MatchMode:whitelist | Remove-CFFirewallRule -Verbose -Whatif