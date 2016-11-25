Function Set-CFRequestData {
<#
.SYNOPSIS
    Sets the parameters for a request to the Cloudflare API.
.DESCRIPTION
    Sets the parameters for a request to the Cloudflare API.
.PARAMETER Uri
    Target URI to send request to.
.PARAMETER Headers
    All the headers in hashtable format you will be sending.
.PARAMETER Body
    The body of the REST request
.PARAMETER Method
    REST method to send. Can be Head, Get, Put, Patch, Post, or Delete. Default is Get.
.EXAMPLE
    TBD
.NOTES
    Author: Zachary Loeber
.LINK
    https://github.com/zloeber/PSCloudFlare
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]$URI,

        [Parameter()]
        [hashtable]$Headers = $Script:Headers,

        [Parameter()]
        [hashtable]$Body = $null,

        [Parameter()]
        [ValidateSet('Head','Get','Put', 'Patch', 'Post', 'Delete')]
        [String]$Method = 'Get'
    )

    $Script:RESTParams = @{
        'Uri' = $URI
        'Headers' = $Headers
        'Body' = $Body
        'Method' = $Method
    }
}