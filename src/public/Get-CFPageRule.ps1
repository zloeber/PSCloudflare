Function Get-CFPageRule {
<#
.SYNOPSIS
    List Cloudflare page rules.
.DESCRIPTION
    List Cloudflare page rules.
.PARAMETER ZoneID
    If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.PARAMETER Status
    Rule status. Can be active, inactive, or null. Default is null (returns both active and inactive rules).
.PARAMETER OrderBy
    Order the results by status or priority. Default is priority.
.PARAMETER Direction
    Return results in asc (ascending) or dec (decending) order. Default is asc.
.PARAMETER MatchScope
    Match either 'any' or 'all' the supplied matching parameters passed to this function. Default is all.
.PARAMETER PageLimit
    Maximum results returned per page. Default is 50.
.EXAMPLE
    PS> Get-CFPageRule

    Shows all cloudflare Page rules for the zone.

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
        [CFPageRuleStatus]$Status,

        [Parameter()]
        [ValidateSet( 'priority', 'status')]
        [string]$OrderBy = 'priority',

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

    $Data = @{
        'direction' = $Direction
        'match' = $MatchScope
        'order' = $Orderby
        'per_page' = $PageLimit
    }

    if ([CFPageRuleStatus]::$Status -ne $null) {
        $Data.status = [CFPageRuleStatus]::$Status
    }

    # Construct the URI for this package
    $Uri = $Script:APIURI + ('/zones/{0}/pagerules' -f $ZoneID)

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