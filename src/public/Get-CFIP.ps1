Function Get-CFIP {
<#
.SYNOPSIS
    Returns Cloudflare IPs.
.DESCRIPTION
    Returns Cloudflare IPs.
.EXAMPLE
    PS> Get-CFIP

    Returns all the ipv4 and 6 Cloudflare IPs.
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param ()

    $Uri = $Script:APIURI + '/ips'

    Set-CFRequestData -Uri $Uri

    try {
        Write-Verbose "$($FunctionName): Returning Cloudflare IPs"
        (Invoke-CFAPI4Request -ErrorAction Stop).result
    }
    catch {
        Throw $_
    }
}