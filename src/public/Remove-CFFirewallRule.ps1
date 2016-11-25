Function Remove-CFFirewallRule {
<#
.SYNOPSIS
    Removes a Cloudflare firewall rule.
.DESCRIPTION
    Removes a Cloudflare firewall rule.
.PARAMETER RuleID
    RuleID to remove
.PARAMETER ZoneID
    You apply firewall rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.EXAMPLE
    TBD
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    Param (
        [Parameter(Mandatory = $True)]
        [ValidateScript({
            ($_ -match '^[a-f0-9]{32}$')
        })]
        [String]$RuleID,

        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID
    )   
    
    # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Remove-CFFirewallRule: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }

    # URI will change if we specified a DNS zone or not
    if (-not ([string]::IsNullOrEmpty($ZoneID))) {
        $Uri = $Script:APIURI +('/zones/{0}/firewall/access_rules/rules/{1}' -f $ZoneID, $RuleID)
    }
    else {
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/{0}' -f $RuleID)
    }

    Set-CFRequestData -Uri $Uri -Method 'Delete'
    
    try {
        Write-Verbose -Message 'Attempting to remove firewall rule...'
        $Response = Invoke-CFAPI4Request -ErrorAction Stop
    }
    catch {
        Throw $_
    }
}