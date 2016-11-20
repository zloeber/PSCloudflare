$Token = 'aaaaaaaaaabbbbbbbbbbccccccccccc1234552'
$Email = 'jdoe@contoso.com'
$Zone = 'contoso.com'

# Connect to the CloudFlare Client API
try {
    Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
}
catch {
    throw $_
}

# Add a firewall rule that challenges the visitor with a CAPTCHA 
Add-CFFirewallRule -Item '192.168.1.0/24' -Notes 'Organization Block 1' -Target 'ip_range' -Mode:challenge -Verbose

# List the firewall rules for the organization
Get-CFFirewallRule -Verbose -ErrorAction Stop

# Target the contoso.com zone
Set-CFCurrentZone -Zone $Zone -Verbose

# Add a firewall rule that challenges the visitor with a CAPTCHA just for the contoso.com zone
Add-CFFirewallRule -Item '10.0.0.1' -Notes 'Zone Block 1' -Target 'ip' -Mode:challenge -Verbose

# List the firewall rules for contoso.com
Get-CFFirewallRule -Verbose -ErrorAction Stop