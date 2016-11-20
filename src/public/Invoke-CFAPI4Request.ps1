Function Invoke-CFAPI4Request {
<#
.SYNOPSIS
    Send REST request to Cloudflare URI.
.DESCRIPTION
    Send REST request to Cloudflare URI.
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
        [Uri]$Uri,
       
        [Parameter()]
        [HashTable]$Headers = $Script:Headers,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Object]$Body = $null,

        [Parameter()]
        [ValidateSet('Head','Get','Put', 'Patch', 'Post', 'Delete')]
        [String]$Method = 'Get'
    )
    
    try {
        $JSONResponse = Invoke-RestMethod -Uri $Uri -Headers $Headers -ContentType 'application/json' -Method $Method -Body $Body -ErrorAction Stop
    }
    catch {
        Write-Debug -Message 'Error Processing in Invoke-CFAPI4Request'
        $MyError = $_
        if ($null -ne $MyError.Exception.Response) {
            try {
                # Recieved an error from the API, lets get it out
                $result = $MyError.Exception.Response.GetResponseStream()
                $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList ($result)
                $responseBody = $reader.ReadToEnd()
                $JSONResponse = $responseBody | ConvertFrom-Json
                
                $CloudFlareErrorCode = $JSONResponse.Errors[0].code
                $CloudFlareMessage = $JSONResponse.Errors[0].message

                # Some errors are just plain unfriendly, so I make them more understandable
                switch ($CloudFlareErrorCode) {
                    9103 {
                        throw '[CloudFlare Error 9103] Your Cloudflare API or email address appears to be incorrect.' 
                    }
                    81019  {
                        throw '[CloudFlare Error 81019] Cloudflare access rule quota has been exceeded: You may be trying to add more access rules than your account currently allows. Please check the --rule-limit option.' 
                    }
                    default {
                        throw '[CloudFlare Error {0}] {1}' -f $CloudFlareErrorCode, $CloudFlareMessage 
                    }
                }
            }
            catch {
                # An error has occured whilst processing the error, so we will just throw the original error
                Throw $MyError
            }
        }
        else {
            # This wasn't an error from the API, so we need to let the user know directly
            Throw $MyError
        }
    }
    Write-Output -InputObject $JSONResponse
}