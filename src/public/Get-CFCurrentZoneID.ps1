Function Get-CFCurrentZoneID {
<#
.SYNOPSIS
    Gets the currently targeted ZoneID.
.DESCRIPTION
    Gets the currently targeted ZoneID.
.EXAMPLE
    Get-CFRequestData
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>
    return $Script:ZoneID
}