Function Get-CFWAFRuleGroup {
<#
.SYNOPSIS
    List Cloudflare WAF rules.
.DESCRIPTION
    List Cloudflare WAF rules.
.PARAMETER ZoneID
    You apply WAF rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.PARAMETER Name
    rule group name. If not supplied then all rule groups are returned.
.PARAMETER OrderBy
    Order the results by configuration_target, configuration_value, or mode. Default is configuration_value
.PARAMETER Direction
    Return results in asc (ascending) or dec (decending) order. Default is asc.
.PARAMETER MatchScope
    Match either 'any' or 'all' the supplied matching parameters passed to this function. Default is all.
.PARAMETER PageLimit
    Maximum results returned per page. Default is 50.
.EXAMPLE
    PS> Get-CFWAFRuleGroup

    Shows all cloudflare WAF rule groups for the zone.

.EXAMPLE
    TBD
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
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$PackageID,
        
        [Parameter()]
        [String]$Name,

        [Parameter()]
        [CFWAFRuleGroupMode]$Mode,

        [Parameter()]
        [ValidateSet( 'mode', 'rules_count' )]
        [string]$OrderBy = 'mode',

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
    elseif ([string]::IsNullOrEmpty($ZoneID)) {
        throw 'No Zone was set or passed!'
    }

    if ([string]::IsNullOrEmpty($PackageID)) {
        Write-Verbose "$($FunctionName): No Package ID passed, pulling all package IDs"
        $PackageIDs = Get-CFWAFRulePackage -ZoneID $ZoneID | Foreach {$_.id}
    }
    else {
        $PackageIDs = @($PackageID)
    }

    $Data = @{
        'direction' = $Direction
        'match' = $MatchScope
        'order' = $Orderby
        'per_page' = $PageLimit
    }
    if (-not ([string]::IsNullOrEmpty($Name))) {
        Write-Verbose "$($FunctionName): Name passed: $Name"
        $Data.name = $Name
    }
    if ([CFWAFRuleGroupMode]::$Mode -ne $null) {
        $Data.mode = [CFWAFRuleGroupMode]::$Mode
    }

    Foreach ($Package in $PackageIDs) {
        Write-Verbose "$($FunctionName): Listing WAF groups within package ID:  $Package."

        # Construct the URI for this package
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/waf/packages/{1}/groups' -f $ZoneID, $Package)

        # Always start at the first page
        $Data.page = 1

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
}