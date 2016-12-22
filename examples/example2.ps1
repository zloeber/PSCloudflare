# Writes a quick report of all page rules for the zone to the console
Import-Module .\PSCloudflare.psm1
$Token = 'aaaaaaaaaabbbbbbbbbbccccccccccc1234552'
$Email = 'jdoe@contoso.com'
$Zone = 'contoso.com'

$PageRules = Get-CFPageRule
Foreach ($PageRule in $PageRules) {
    Write-Output "Rule #$($PageRule.priority) ="
    Write-Output "  Target: $($PageRule.targets.constraint.value)"
    Write-Output "  Actions:"
    $PageRule.Actions | ForEach-Object {
        Write-Output "    $($_.id) - $($_.value)"
    }
}