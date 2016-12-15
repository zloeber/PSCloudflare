Function Get-CFTrafficLog {
<#
.SYNOPSIS
    List Cloudflare traffic logs.
.DESCRIPTION
    List Cloudflare traffic logs.
.PARAMETER ZoneID
    You apply firewall rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.PARAMETER OrderBy
    Order the results by id, action, host, ip, country, or occurred_at. Default is occurred_at.
.PARAMETER Direction
    Return results in asc (ascending) or dec (decending) order. Default is asc.
.PARAMETER PageLimit
    Maximum results returned per page. Default is 50. Max is 500.
.EXAMPLE
    PS> Get-CFTrafficLog

    Shows all cloudflare firewall rules at the top of the organization
.EXAMPLE
    PS> Set-CFCurrentZone 'contoso.org'
    PS> Get-CFTrafficLog

    Shows all cloudflare firewall rules for the contoso.org zone.
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
        [ValidateSet( 'id', 'action', 'host', 'ip', 'country', 'occurred_at')]
        [string]$OrderBy = 'occurred_at',

        [Parameter()]
        [ValidateSet( 'asc', 'dec' )]
        [string]$Direction = 'asc',

        [Parameter()]
        [ValidateRange(1,500)]
        [int]$PageLimit = 50
    )  

    $FunctionName = $MyInvocation.MyCommand.Name

    # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "$($FunctionName): No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }

     # If we specified a zone earlier, then we call the zone page
     # https://www.cloudflare.com/api/v4/zones/[zoneID]/firewall/events?page=1&per_page=50
    if ([string]::IsNullOrEmpty($ZoneID)) {
        $Uri = $Script:APIURI + ('/user/firewall/events/')
    }
    else {
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/events' -f $ZoneID)
    }  


    $Data = @{
        'direction' = $Direction
        'order' = $Orderby
        'per_page' = $PageLimit
        'page' = 1
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