# PSCloudflare Module

This is a powershell module for interacting more easily with the Cloudflare RESTful API.

[TOC]

## Introduction
Firstly the original script I based this on can be located **[Here](https://github.com/poshsecurity/PowerShell-CloudFlare-Tor-Whitelist)**

This module tears apart the original script and converts it into a proper module. In the process I've added a few improvements:
- Implemented a proper build process
- Added documentation
- Generalized the functions
- Added validation around some of the parameters

This starts with a few functions I needed to add a large number of firewall rules but can be very easily added and expanded upon to suit your needs. The full documentation for the api can be found **[Here](https://api.cloudflare.com/)**

## Example
Here is a small example of some stuff you can do thus far.
```
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
```

## Credits
**Original Script:** [https://github.com/poshsecurity/PowerShell-CloudFlare-Tor-Whitelist](https://github.com/poshsecurity/PowerShell-CloudFlare-Tor-Whitelist)
**Cloudflare API Documentation:** [https://api.cloudflare.com/](https://api.cloudflare.com/)