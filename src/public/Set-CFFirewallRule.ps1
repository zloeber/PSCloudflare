Function Set-CFFirewallRule {
<#
.SYNOPSIS
    Modifies a cloudflare firewall rule.
.DESCRIPTION
    Modifies a cloudflare firewall rule.
.PARAMETER ZoneID
    You apply firewall rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.PARAMETER ID
    The firewall ID you would like to modify.
.PARAMETER Item
    This can be an IP, IP range (Cidr notation), ASN (AS####), or 2 letter Country code
.PARAMETER Target
    Are you adding an IP, IP_Range, ASN, or Country?
.PARAMETER Mode
    What is this rule going to do? Options include whitelist, block, challenge, js_challenge. Default is to whitelist.
.PARAMETER Notes
    Any additional notes for the added firewall rule
.EXAMPLE
    PS> Set-CFFirewallRule -ZoneID $ZoneID -Item '96.9.128.0/24' -Notes 'Load Balancer Ip Block - 4.1' -Target 'ip_range' -Mode:challenge -Verbose
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [ValidateScript({ IsNullOrCFID $_ })]
        [String]$ZoneID,
        
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({ IsCFID $_ })]
        [String[]]$ID,

        [Parameter()]
        [String]$Item = $null,

        [Parameter()]
        [CFFirewallTarget]$Target,

        [Parameter()]
        [CFFirewallMode]$Mode,

        [Parameter()] 
        [String]$Notes = $null
    )

    Begin {
        $FunctionName = $MyInvocation.MyCommand.Name

        # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
        if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
            Write-Verbose "$($FunctionName): No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
            $ZoneID = $Script:ZoneID
        }

        $Data = @{}

        if ([CFFirewallMode]::$Mode -ne $null) {
            $Data.mode = [CFFirewallMode]::$Mode
        }
        if ($Notes -ne $null) {
            $Data.notes = $Notes
        }
        Write-Verbose "$($FunctionName): Target parameter = $([CFFirewallTarget]::$Target)"
        switch ([CFFirewallTarget]::$Target) {
            'ip' { 
                if (-not ($Item -match [IPAddress]$Item)) { 
                    throw 'IP address is not valid'
                }
            }
            'ip_range' {
                if (-not (IsIPRange $Item)) {
                    throw "Subnet address '$Item' does not match the expected CIDR format (example:  192.168.0.0/24)"
                }
            }
            'country' {
                if (-not (IsCountryCode $Item)) {
                    throw "Country code '$Item' does not match the expected country code format (example: US)"
                }
            }
            'asn' {
                if ($Item -notmatch '^(AS\d+)$') {
                    throw "ASN '$Item' does not match the expected ASN format (example: AS1234)"
                }
            }
            default {}
        }
        if ( -not [string]::IsNullOrEmpty($Item -ne $null)) {
            Write-Verbose "$($FunctionName): A Target and Item were passed ($($Item) - $([CFFirewallTarget]::$Target)), adding this to the data request."
            $Data.configuration = @{
                'value' = $Item
                'target' = [CFFirewallTarget]::$Target
            }
        }
    }
    Process {
        $ID | Foreach {
            $ThisID = $_
            # If we specified a zone earlier, create the access rules there, else, do it at a user level
            if (-not ([string]::IsNullOrEmpty($ZoneID))) {
                Write-Verbose "$($FunctionName): Targeting only $($Script:ZoneName) for this firewall rule."
                $Uri = $Script:APIURI + ('/zones/{0}/firewall/access_rules/rules/{1}' -f $ZoneID, $ThisID)
                $Data.group = @{
                    'id' = 'zone'
                }
            }
            else {
                Write-Verbose "$($FunctionName): Targeting entire organization for this firewall rule."
                $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/{0}' -f $ThisID)
                $Data.group = @{
                    'id' = 'owner'
                }
            }
            
            Write-Verbose "$($FunctionName): URI = '$Uri'"

            try {
                Set-CFRequestData -Uri $Uri -Body $Data -Method 'Patch'
                $Response = Invoke-CFAPI4Request -ErrorAction Stop
            }
            catch {
                Throw $_
            }
        }
    }
}