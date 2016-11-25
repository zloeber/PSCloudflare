Function Add-CFFirewallRule {
<#
.SYNOPSIS
    Adds a cloudflare firewall rule.
.DESCRIPTION
    Adds a cloudflare firewall rule.
.PARAMETER Item
    This can be an IP, IP range (Cidr notation), ASN (AS####), or 2 letter Country code
.PARAMETER ZoneID
    You apply firewall rules to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
.PARAMETER Target
    Are you adding an IP, IP_Range, ASN, or Country?
.PARAMETER Mode
    What is this rule going to do? Options include whitelist, block, challenge, js_challenge. Default is to whitelist.
.PARAMETER Notes
    Any additional notes for the added firewall rule
.EXAMPLE
    PS> Add-CFFirewallRule -ZoneID $ZoneID -Item '96.9.128.0/24' -Notes 'Load Balancer Ip Block - 4.1' -Target 'ip_range' -Mode:challenge -Verbose
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]$Item,

        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID,

        [Parameter()]
        [ValidateSet('ip','ip_range','country','asn')]
        [String]$Target = 'ip',

        [Parameter()]
        [ValidateSet('whitelist','block','challenge','js_challenge')]
        [String]$Mode = 'whitelist',

        [Parameter()]
        [String]$Notes = ''
    )
    
    switch ($Target) {
        'ip' { 
            if (-not ($Item -match [IPAddress]$Item)) { 
                throw 'IP address is not valid'
            }
        }
        'ip_range' {
            if ($Item -notmatch '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$') {
                throw "Subnet address '$Item' does not match the expected CIDR format (example:  192.168.0.0/24)"
            }
        }
        'country' {
            if ($Item -notmatch '^(AF|AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BQ|BA|BW|BV|BR|IO|BN|BG|BF|BI|KH|CM|CA|CV|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CW|CY|CZ|DK|DJ|DM|DO|EC|EG|SV|GQ|ER|EE|ET|FK|FO|FJ|FI|FR|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|VA|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MK|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|RE|RO|RU|RW|BL|SH|KN|LC|MF|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SX|SK|SI|SB|SO|ZA|GS|SS|ES|LK|SD|SR|SJ|SZ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UM|UY|UZ|VU|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$') {
                throw "Country code '$Item' does not match the expected country code format (example: US)"
            }
        }
        'asn' {
            if ($Item -notmatch '^(AS\d+)$') {
                throw "ASN '$Item' does not match the expected ASN format (example: AS1234)"
            }
        }
        default {
            throw 'How did we get here?'
        }
    }

    # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Add-CFFirewallRule: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }

    # If we specified a zone earlier, create the access rules there, else, do it at a user level
    if (-not ([string]::IsNullOrEmpty($ZoneID))) {
        Write-Verbose "Add-CFFirewallRule: Targeting only $($Script:ZoneName) for this firewall rule."
        $Data = @{
            'mode' = $Mode
            'notes' = $Notes
            'configuration' = @{
                'value' = $Item
                'target' = $Target
            }
            'group' = @{
                'id' = 'zone'
            }
        }
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/access_rules/rules' -f $ZoneID)
    }
    else {
        Write-Verbose "Add-CFFirewallRule: Targeting entire organization for this firewall rule."
        $Data = @{
            'mode' = $Mode
            'notes' = $Notes
            'configuration' = @{
                'value' = $Item
                'target' = $Target
            }
            'group' = @{
                'id' = 'owner'
            }
        }
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules')
    }
    
    Write-Verbose "Add-CFFirewallRule: URI = '$Uri'"

    try {
        Write-Verbose -Message "Add-CFFirewallRule: Adding '$Item' as '$Target' in '$Mode' mode..."

        Set-CFRequestData -Uri $Uri -Body $Data -Method 'Post'
        $Response = Invoke-CFAPI4Request -ErrorAction Stop
    }
    catch {
        Throw $_
    }
}