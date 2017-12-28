function Add-CFDNSRecord {
    <#
    .SYNOPSIS
    Adds a cloudflare dns record.
    .DESCRIPTION
    Adds a cloudflare dns record.
    .PARAMETER ZoneID
    You apply dns records to individual zones or to the whole organization. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
    .PARAMETER RecordType
    Type of record to modify.
    .PARAMETER ID
    The dns record ID you would like to modify. If not defined it will be derived from the Name and RecordType parameters.
    .PARAMETER Name
    name of the record to modify.
    .PARAMETER Content
    DNS record value write.
    .PARAMETER TTL
    Time to live, optional update setting. Default is 120.
    .Parameter Proxied
    Set or unset orange cloud mode for a record. Optional.
    .EXAMPLE
    TBD
    .LINK
    https://github.com/zloeber/PSCloudFlare
    .NOTES
    Author: Zachary Loeber
    #>
    [CmdletBinding()]
    Param (
        [Parameter()]
        [ValidateScript({ IsNullOrCFID $_ })]
        [String]$ZoneID,

        [Parameter(Mandatory = $true)]
        [CFDNSRecordType]$RecordType,

        [Parameter(Mandatory=$true)]
        [String]$Name = $null,

        [Parameter(Mandatory=$true)]
        [String]$Content,

        [Parameter()]
        [ValidateRange(120,2147483647)]
        [int]$TTL = 120,

        [Parameter()]
        [CFDNSOrangeCloudMode]$Proxied
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

        $Data = @{
            type = $RecordType.ToString()
            name = $Name
            content = $Content
        }


        switch ($Proxied) {
            'on' {
                $Data.proxied = $true
            }
            'off' {
                $Data.proxied = $false
            }
        }

        if ($null -ne $TTL) {
            $Data.ttl = $TTL
        }

    }
    end {
        # Construct the URI for this package
        $Uri = $Script:APIURI + ('/zones/{0}/dns_records' -f $ZoneID)
        Write-Verbose "$($FunctionName): URI = '$Uri'"

        try {
            Set-CFRequestData -Uri $Uri -Body $Data -Method 'Post'
            $Response = Invoke-CFAPI4Request -ErrorAction Stop
        }
        catch {
            Throw $_
        }

        Write-Verbose "$($FunctionName): End."
    }
}