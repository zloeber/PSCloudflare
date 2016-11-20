Function Get-CFFirewallRule {
<#
.SYNOPSIS
    List Cloudflare firewall rules.
.DESCRIPTION
    List Cloudflare firewall rules.
.PARAMETER ZoneID
    You apply firewall rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.EXAMPLE
    PS> Get-CFFirewallRule
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID
    )  
    
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Get-CFFirewallRulePage: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }
    
    # Get the first page, from there we will be able to see the total page numbers
    try {
        $LatestPage = Get-CFFirewallRulePage -ZoneID $ZoneID -PageNumber 1 -ErrorAction Stop
        $result = $LatestPage.result
        $TotalPages = $LatestPage.result_info.total_pages
    }
    catch {
        throw $_
    }

    $PageNumber = 2
    
    # Get any more pages
    while ($PageNumber -le $TotalPages) {
        try {
            $LatestPage = Get-CFFirewallRulePage -ZoneID $ZoneID -PageNumber $PageNumber -ErrorAction Stop
            $result += $LatestPage.result
            $PageNumber++
        }
        catch {
            throw $_
            break
        }
    }

    $result
}