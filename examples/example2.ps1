# Writes a quick report of all page rules for the zone to the console
Import-Module .\PSCloudflare.psm1
$Token = 'cbf4eb75bc838f2f832a15bd91c9698774aca'
$Token = '00000000000000000000000000000000000'
$Email = 'itops@contoso.com'
$Zone = 'contoso.com'
Connect-CFClientAPI -APIToken $Token -EmailAddress $Email -ErrorAction Stop
Set-CFCurrentZone -Zone $Zone

$PageRules = Get-CFPageRule
Foreach ($PageRule in $PageRules) {
    Write-Output "Rule #$($PageRule.priority) ="
    Write-Output "  Target: $($PageRule.targets.constraint.value)"
    Write-Output "  Actions:"
    $PageRule.Actions | Foreach {
        Write-Output "    $($_.id) - $($_.value)"
    }
}