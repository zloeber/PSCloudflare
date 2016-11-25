Function Get-CFZoneID {
<#
.SYNOPSIS
    Returns the ZoneID of the passed zone name (if it exists)
.DESCRIPTION
    Returns the ZoneID of the passed zone name (if it exists)
.PARAMETER Zone
    Zone name.

.EXAMPLE
    Get-CFZoneID -Zone 'contoso.com'
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]$Zone
    )

    $Uri = $Script:APIURI + '/zones'

    Set-CFRequestData -Uri $Uri

    try {
        Write-Verbose -Message 'Getting Zone information'
        $Response = Invoke-CFAPI4Request #-Uri $Uri -Headers $Headers -ErrorAction Stop
    }
    catch {
        Throw $_
    }

    $ZoneData = $Response.Result | Where-Object -FilterScript {
        $_.name -eq $Zone
    }
    
    if ($null -ne $ZoneData) {
        $ZoneData.ID
    }
    else {
        throw 'Zone not found in CloudFlare'
    }
}