Function Get-CFFirewallRule {
<#
.SYNOPSIS
    List Cloudflare firewall rules.
.DESCRIPTION
    List Cloudflare firewall rules.
.PARAMETER ZoneID
    You apply firewall rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.PARAMETER MatchItem
    This can be an IP, IP range (Cidr notation), ASN (AS####), or 2 letter Country code if matching by Target in your search. Default is null (match all items).
.PARAMETER MatchTarget
    Are you matching an IP, IP_Range, ASN, or Country?
.PARAMETER MatchMode
    Matches only firewall rules with this mode. Options include whitelist, block, challenge, js_challenge. Default is null (match all modes)
.PARAMETER OrderBy
    Order the results by configuration_target, configuration_value, or mode. Default is configuration_value
.PARAMETER Direction
    Return results in asc (ascending) or dec (decending) order. Default is asc.
.PARAMETER MatchScope
    Match either 'any' or 'all' the supplied matching parameters passed to this function. Default is all.
.PARAMETER PageLimit
    Maximum results returned per page. Default is 50.
.EXAMPLE
    PS> Get-CFFirewallRule

    Shows all cloudflare firewall rules at the top of the organization
.EXAMPLE
    PS> Set-CFCurrentZone 'contoso.org'
    PS> Get-CFFirewallRule

    Shows all cloudflare firewall rules for the contoso.org zone.
.EXAMPLE
    PS> Get-CFFirewallRule -MatchMode whitelist

    Shows only whitelist firewall items
.EXAMPLE
    PS> Get-CFFirewallRule -MatchMode whitelist -MatchItem '4.2.2.2' -MatchScope any

    Returns any whitelisted item that matches 4.2.2.2
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
        [String]$ZoneID,

        [Parameter()]
        [String]$MatchItem = $null,

        [Parameter()]
        [CFFirewallTarget]$MatchTarget,

        [Parameter()]
        [CFFirewallMode]$MatchMode,

        [Parameter()]
        [ValidateSet( 'configuration_target', 'configuration_value', 'mode' )]
        [string]$OrderBy = 'configuration_value',

        [Parameter()]
        [ValidateSet( 'asc', 'dec' )]
        [string]$Direction = 'asc',

        [Parameter()]
        [ValidateSet( 'any', 'all' )]
        [string]$MatchScope = 'all',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$PageLimit = 50
    )

    $FunctionName = $MyInvocation.MyCommand.Name

    # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "$($FunctionName): No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }

     # If we specified a zone earlier, then we call the zone page
    if ([string]::IsNullOrEmpty($ZoneID)) {
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/')
    }
    else {
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/access_rules/rules' -f $ZoneID)
    }


    $Data = @{
        'direction' = $Direction
        'match' = $MatchScope
        'order' = $Orderby
        'per_page' = $PageLimit
        'page' = 1
    }

    if ($null -ne [CFFirewallMode]::$MatchMode) {
        $Data.mode = $MatchMode.ToString()
    }

    if ( (-not [string]::IsNullOrEmpty($MatchItem)) -and (-not [string]::IsNullOrEmpty([CFFirewallTarget]::$MatchTarget)))  {
        Write-Verbose "$($FunctionName): A MatchTarget and MatchItem were passed ($($MatchItem) - $([CFFirewallTarget]::$MatchTarget)), adding this to the data request."
        $Data.configuration_value = $MatchItem
        $Data.configuration_target = $MatchTarget.ToString()
    }

    # Get the first page, from there we will be able to see the total page numbers
    try {
        Write-Verbose "$($FunctionName): Returning the first result"
        Set-CFRequestData -Uri $Uri -Body $Data
        $LatestPage = Invoke-CFAPI4Request -ErrorAction Stop
        $LatestPage.result
        $TotalPages = $LatestPage.result_info.total_pages
    }
    catch {
        throw $_
    }

    $PageNumber = 2

    # Get any more pages
    while ($PageNumber -le $TotalPages) {
        try {
             Write-Verbose "$($FunctionName): Returning $PageNumber of $TotalPages"
            $Data.page = $PageNumber
            Set-CFRequestData -Uri $Uri -Body $Data
            (Invoke-CFAPI4Request -ErrorAction Stop).result
            $PageNumber++
        }
        catch {
            throw $_
            break
        }
    }
}