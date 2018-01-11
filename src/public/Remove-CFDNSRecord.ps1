function Remove-CFDNSRecord {
    <#
    .SYNOPSIS
    Removes a cloudflare dns record.
    .DESCRIPTION
    Removes a cloudflare dns record.
    .PARAMETER ZoneID
    You apply dns records to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
    .PARAMETER ID
    The dns record ID you would like to modify. If not defined it will be derived from the Name and RecordType parameters.
    .EXAMPLE
    Remove-CFDNSRecord -ZoneId abcdef0123456789abcdef0123456789 -ID 0123456789abcdef0123456789abcdef
    .LINK
    https://github.com/zloeber/PSCloudFlare
    .NOTES
    Author: Karl Barbour
    #>
    [CmdletBinding()]
    Param (
        [Parameter()]
        [ValidateScript({ IsNullOrCFID $_ })]
        [String]$ZoneID,

        [Parameter(Mandatory=$true)]
        [String]$ID
    )
    begin {
        if ($script:ThisModuleLoaded -eq $true) {
            Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
        }
        $FunctionName = $MyInvocation.MyCommand.Name
        Write-Verbose "$($FunctionName): Begin."

        # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
        if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
            Write-Verbose "$($FunctionName): No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
            $ZoneID = $Script:ZoneID
        }
        elseif ([string]::IsNullOrEmpty($ZoneID)) {
            throw 'No Zone was set or passed!'
        }
    }
    end {
        # Construct the URI for this package
        $Uri = $Script:APIURI + ('/zones/{0}/dns_records/{1}' -f $ZoneID,$ID)
        Write-Verbose "$($FunctionName): URI = '$Uri'"

        try {
            Set-CFRequestData -Uri $Uri -Method 'Delete'
            $Response = Invoke-CFAPI4Request -ErrorAction Stop
        }
        catch {
            Throw $_
        }

        Write-Verbose "$($FunctionName): End."
    }
}