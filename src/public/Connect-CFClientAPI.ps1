Function Connect-CFClientAPI {
<#
.SYNOPSIS
    Connects to the CloudFlare API for future requests.
.DESCRIPTION
    Connects to the CloudFlare API for future requests.
.PARAMETER APIToken
    The Cloudflare API token.
.PARAMETER EmailAddress
    The associated email address with this Cloudflare API token.

.EXAMPLE
    PS> Connect-CFClientAPI -APIToken xxxxxxxxxxxxxxxxxxxxx -EmailAddress 'jdoe@contoso.com'
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]$APIToken,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]$EmailAddress
    )

    # Headers for CloudFlare APIv4
    $Headers = @{
        'X-Auth-Key'   = $APIToken
        'X-Auth-Email' = $EmailAddress
    }

    $Uri = $Script:APIURI + '/user'

    Set-CFRequestData -Uri $Uri -Headers $Headers

    try {
        Write-Verbose  'Connect-CFClientAPI: Attempting to connect'
        $null = Invoke-CFAPI4Request -ErrorAction Stop
        Write-Verbose 'Connect-CFClientAPI: Connected successfully'

        # Make the headers we used available accross the entire script scope
        $Script:Headers = $Headers
    }
    catch {
        Throw $_
    }
}