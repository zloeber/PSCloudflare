Function Get-CFFirewallRulePage {
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID,

        [Parameter(Mandatory = $True)]
        [int]$PageNumber,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$PageLimit = 50
    )
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Get-CFFirewallRulePage: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }
    # Need to send page number and limit as part of request
    $Data = @{
        'page' = $PageNumber
        'per_page' = $PageLimit
    }
    
    # If we specified a zone earlier, then we call the zone page
    if ([string]::IsNullOrEmpty($ZoneID)) {
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/')
    }
    else {
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/access_rules/rules' -f $ZoneID)
    }  

    Write-Verbose "Get-CFFirewallRulePage: Page Number = '$PageNumber'"
    try {
        Set-CFRequestData -Uri $Uri -Body $Data

        $Response = Invoke-CFAPI4Request -ErrorAction Stop
    }
    catch {
        throw $_
    }

    Write-Output -InputObject $Response
}