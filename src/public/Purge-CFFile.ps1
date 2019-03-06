# Purge Files by URL, Cache-Tags or Host
function Purge-CFFile {
    <#
    .SYNOPSIS
    Purge Files by URL, Cache-Tags or Host
    .DESCRIPTION
    Purge Files by URL, Cache-Tags or Host
    .PARAMETER ZoneID
    ZoneID. If you pass ZoneID it will be targeted otherwise the currently loaded zone from Set-CFCurrentZone is targeted.
    .PARAMETER Everything
    Purge everything
    .PARAMETER Url
    Purge a single URL
    .PARAMETER Urls
    Purge multiple URLs
    .PARAMETER CacheTags
    Purge by cache tags
    .PARAMETER Hosts
    Purge by hosts
    .EXAMPLE
    Purge-CFFile -Urls $StaleUrls
    .NOTES
    Author: Leo
    #>
    [CmdletBinding()]
    Param (
        [Parameter()]
        [ValidateScript({ IsNullOrCFID $_ })]
        [String]$ZoneID
    ,
        [Parameter(ParameterSetName='Everything')]
        [ValidateNotNullOrEmpty()]
        [switch]$Everything
    ,
        [Parameter(ParameterSetName='SingleURL')]
        [ValidateNotNullOrEmpty()]
        [string]$Url
    ,
        [Parameter(ParameterSetName='MultipleURLs')]
        [ValidateNotNullOrEmpty()]
        [array]$Urls
    ,
        [Parameter(ParameterSetName='CacheTagsOrHosts')]
        [ValidateNotNullOrEmpty()]
        [array]$CacheTags
        ,
        [Parameter(ParameterSetName='CacheTagsOrHosts')]
        [ValidateNotNullOrEmpty()]
        [array]$Hosts
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
        $Uri = $Script:APIURI + ('/zones/{0}/purge_cache' -f $ZoneID)
        Write-Verbose "$($FunctionName): URI = '$Uri'"

        # Prepare the body
        switch ($PSCmdlet.ParameterSetName) {
            'Everything' {
                $Data = @{
                    purge_everything = $true
                }
                break
            }
            'SingleURL' {
                # Wrap a single URL in an array
                $Data = @{
                    files = @( $Url )
                }
                break
            }
            'MultipleURLs' {
                $Data = @{
                    files = $Urls
                }
                break
            }
            'CacheTagsOrHosts' {
                $Data = @{}
                if ($CacheTags) {
                    $Data['tags'] = $CacheTags
                }
                if ($Hosts) {
                    $Data['hosts'] = $Hosts
                }
                break
            }
            default {}
        }

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