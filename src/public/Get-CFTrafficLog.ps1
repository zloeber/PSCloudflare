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
.PARAMETER ResultLimit
    Maximum page results returned. Default is 0 (unlimited).
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
        [int]$PageLimit = 50,

        [Parameter()]
        [int]$ResultLimit = 0
    )  
    Begin {
        $FunctionName = $MyInvocation.MyCommand.Name

        # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
        if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
            Write-Verbose "$($FunctionName): No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
            $ZoneID = $Script:ZoneID
        }

        # If we specified a zone earlier, then we call the zone page
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
        }
    }

    Process {
        $ResultCount = 0

        Do {
            $ResultCount++
            Write-Verbose "$($FunctionName): Returning result #$($ResultCount)"
            if ($LatestPage.result_info.next_page_id) {
                $Data.page_id = $LatestPage.result_info.next_page_id
            }

            Set-CFRequestData -Uri $Uri -Body $Data

            try {
                $LatestPage = Invoke-CFAPI4Request -ErrorAction Stop

                # Something about the results in this api query requires us to return it as an array
                @($LatestPage.result)
            }
            catch {
                throw $_
                break
            }

            Write-Verbose "$($FunctionName): Next page result ID = $($LatestPage.result_info.next_page_id)"
        } Until ([string]::IsNullOrEmpty($LatestPage.result_info.next_page_id) -or (($ResultCount -ge $ResultLimit) -and ($ResultLimit -ne 0) )  )
    }
}