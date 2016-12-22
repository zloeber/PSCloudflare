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
    Remove-CFFirewallRule -RuleID 54274c4cda768def3ca6097c95021155
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>
    [CmdletBinding( SupportsShouldProcess = $true )]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName=$True, position=0)]
        [ValidateScript({
            ($_ -match '^[a-f0-9]{32}$')
        })]
        [Alias('id')]
        [String]$RuleID,

        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID
    )   
    
    Begin {
        $FunctionName = $MyInvocation.MyCommand.Name

        # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
        if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
            Write-Verbose "$($FunctionName): No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
            $ZoneID = $Script:ZoneID
        }
    }

    Process {
        # URI will change if we specified a DNS zone or not
        if (-not ([string]::IsNullOrEmpty($ZoneID))) {
            $Uri = $Script:APIURI +('/zones/{0}/firewall/access_rules/rules/{1}' -f $ZoneID, $RuleID)
        }
        else {
            $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/{0}' -f $RuleID)
        }

        Set-CFRequestData -Uri $Uri -Method 'Delete'
        
        if ($pscmdlet.ShouldProcess( "Firewall Rule ID $($RuleID)")) {
            try {
                Write-Verbose -Message "$($FunctionName): Attempting to remove firewall rule ID $($RuleID)"
                $Response = Invoke-CFAPI4Request -ErrorAction Stop
            }
            catch {
                Throw $_
            }
        }
    }
}