Function Set-CFCurrentZone {
<#
.SYNOPSIS
    Sets the currently targeted zone for other functions
.DESCRIPTION
    Sets the currently targeted zone for other functions
.PARAMETER Zone
    The zone domain name

.EXAMPLE
    Set-CFCurrentZone -Zone 'contoso.com'
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [String]$Zone
    )

    if ([string]::IsNullOrEmpty($Zone)) {
        Write-Verbose -Message ('Set-CFCurrentZone: Unsetting the targetted DNS zone.')
        $Script:ZoneID = $null
        $Script:ZoneName = $null
    }
    else {
        try {
            Write-Verbose -Message ('Set-CFCurrentZone: Attempting to get Zone id for {0}' -f $Zone)
            $Script:ZoneID = Get-CFZoneID -Zone $Zone -ErrorAction Stop
            $Script:ZoneName = $Zone
            Write-Verbose -Message ('Set-CFCurrentZone: Zone id is {0}' -f $Script:ZoneID)
        }
        catch {
            throw $_
        }
    }

}
