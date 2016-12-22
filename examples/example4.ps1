# List 3 pages of traffic log entries.
Import-Module .\PSCloudflare.psm1
$Token = 'aaaaaaaaaabbbbbbbbbbccccccccccc1234552'
$Email = 'jdoe@contoso.com'
$Zone = 'contoso.com'

Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
Set-CFCurrentZone -Zone $Zone

Get-CFTrafficLog -Verbose -ResultLimit 3