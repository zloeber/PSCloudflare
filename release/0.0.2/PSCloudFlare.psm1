## Pre-Loaded Module code ##

# Used to determine if we are connected to anything
$Script:Headers = $null

# Used to always have a recent set of parameters used to invoke a REST method
$Script:RESTParams = @{
    'Uri' = $null
    'Headers' = $null
    'Body' = @{}
    'Method' = 'Get'
}

# Used for keeping track of the current zone
$Script:ZoneID = $null
$Script:ZoneName = $null

# Just in case the URI changes in the future
$Script:APIURI = 'https://api.cloudflare.com/client/v4'



## PRIVATE MODULE FUNCTIONS AND DATA ##

function Get-CallerPreference {
    <#
    .Synopsis
       Fetches "Preference" variable values from the caller's scope.
    .DESCRIPTION
       Script module functions do not automatically inherit their caller's variables, but they can be
       obtained through the $PSCmdlet variable in Advanced Functions.  This function is a helper function
       for any script module Advanced Function; by passing in the values of $ExecutionContext.SessionState
       and $PSCmdlet, Get-CallerPreference will set the caller's preference variables locally.
    .PARAMETER Cmdlet
       The $PSCmdlet object from a script module Advanced Function.
    .PARAMETER SessionState
       The $ExecutionContext.SessionState object from a script module Advanced Function.  This is how the
       Get-CallerPreference function sets variables in its callers' scope, even if that caller is in a different
       script module.
    .PARAMETER Name
       Optional array of parameter names to retrieve from the caller's scope.  Default is to retrieve all
       Preference variables as defined in the about_Preference_Variables help file (as of PowerShell 4.0)
       This parameter may also specify names of variables that are not in the about_Preference_Variables
       help file, and the function will retrieve and set those as well.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Imports the default PowerShell preference variables from the caller into the local scope.
    .EXAMPLE
       Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -Name 'ErrorActionPreference','SomeOtherVariable'

       Imports only the ErrorActionPreference and SomeOtherVariable variables into the local scope.
    .EXAMPLE
       'ErrorActionPreference','SomeOtherVariable' | Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

       Same as Example 2, but sends variable names to the Name parameter via pipeline input.
    .INPUTS
       String
    .OUTPUTS
       None.  This function does not produce pipeline output.
    .LINK
       about_Preference_Variables
    #>

    [CmdletBinding(DefaultParameterSetName = 'AllVariables')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_.GetType().FullName -eq 'System.Management.Automation.PSScriptCmdlet' })]
        $Cmdlet,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.SessionState]$SessionState,

        [Parameter(ParameterSetName = 'Filtered', ValueFromPipeline = $true)]
        [string[]]$Name
    )

    begin {
        $filterHash = @{}
    }
    
    process {
        if ($null -ne $Name)
        {
            foreach ($string in $Name)
            {
                $filterHash[$string] = $true
            }
        }
    }

    end {
        # List of preference variables taken from the about_Preference_Variables help file in PowerShell version 4.0

        $vars = @{
            'ErrorView' = $null
            'FormatEnumerationLimit' = $null
            'LogCommandHealthEvent' = $null
            'LogCommandLifecycleEvent' = $null
            'LogEngineHealthEvent' = $null
            'LogEngineLifecycleEvent' = $null
            'LogProviderHealthEvent' = $null
            'LogProviderLifecycleEvent' = $null
            'MaximumAliasCount' = $null
            'MaximumDriveCount' = $null
            'MaximumErrorCount' = $null
            'MaximumFunctionCount' = $null
            'MaximumHistoryCount' = $null
            'MaximumVariableCount' = $null
            'OFS' = $null
            'OutputEncoding' = $null
            'ProgressPreference' = $null
            'PSDefaultParameterValues' = $null
            'PSEmailServer' = $null
            'PSModuleAutoLoadingPreference' = $null
            'PSSessionApplicationName' = $null
            'PSSessionConfigurationName' = $null
            'PSSessionOption' = $null

            'ErrorActionPreference' = 'ErrorAction'
            'DebugPreference' = 'Debug'
            'ConfirmPreference' = 'Confirm'
            'WhatIfPreference' = 'WhatIf'
            'VerbosePreference' = 'Verbose'
            'WarningPreference' = 'WarningAction'
        }

        foreach ($entry in $vars.GetEnumerator()) {
            if (([string]::IsNullOrEmpty($entry.Value) -or -not $Cmdlet.MyInvocation.BoundParameters.ContainsKey($entry.Value)) -and
                ($PSCmdlet.ParameterSetName -eq 'AllVariables' -or $filterHash.ContainsKey($entry.Name))) {
                
                $variable = $Cmdlet.SessionState.PSVariable.Get($entry.Key)
                
                if ($null -ne $variable) {
                    if ($SessionState -eq $ExecutionContext.SessionState) {
                        Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                    }
                    else {
                        $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                    }
                }
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Filtered') {
            foreach ($varName in $filterHash.Keys) {
                if (-not $vars.ContainsKey($varName)) {
                    $variable = $Cmdlet.SessionState.PSVariable.Get($varName)
                
                    if ($null -ne $variable)
                    {
                        if ($SessionState -eq $ExecutionContext.SessionState)
                        {
                            Set-Variable -Scope 1 -Name $variable.Name -Value $variable.Value -Force -Confirm:$false -WhatIf:$false
                        }
                        else
                        {
                            $SessionState.PSVariable.Set($variable.Name, $variable.Value)
                        }
                    }
                }
            }
        }
    }
}



Function Get-CFFirewallRulePage {
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID,

        [Parameter(Mandatory = $True)]
        [int]$PageNumber,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$PageLimit = 50
    )
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Get-CFFirewallRulePage: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }
    # Need to send page number and limit as part of request
    $Data = @{
        'page' = $PageNumber
        'per_page' = $PageLimit
    }
    
    # If we specified a zone earlier, then we call the zone page
    if ([string]::IsNullOrEmpty($ZoneID)) {
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/')
    }
    else {
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/access_rules/rules' -f $ZoneID)
    }  

    Write-Verbose "Get-CFFirewallRulePage: Page Number = '$PageNumber'"
    try {
        Set-CFRequestData -Uri $Uri -Body $Data

        $Response = Invoke-CFAPI4Request -ErrorAction Stop
    }
    catch {
        throw $_
    }

    Write-Output -InputObject $Response
}



Function IsNullOrCFID ([string]$ID) {
    if (-not ([string]::IsNullOrEmpty($ID))) {
        return ($ID -match '^[a-f0-9]{32}$')
    }
    else {
        return $true
    }
}



## PUBLIC MODULE FUNCTIONS AND DATA ##

Function Add-CFFirewallRule {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Add-CFFirewallRule.md
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]$Item,

        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID,

        [Parameter()]
        [ValidateSet('ip','ip_range','country','asn')]
        [String]$Target = 'ip',

        [Parameter()]
        [ValidateSet('whitelist','block','challenge','js_challenge')]
        [String]$Mode = 'whitelist',

        [Parameter()]
        [String]$Notes = ''
    )
    
    switch ($Target) {
        'ip' { 
            if (-not ($Item -match [IPAddress]$Item)) { 
                throw 'IP address is not valid'
            }
        }
        'ip_range' {
            if ($Item -notmatch '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$') {
                throw "Subnet address '$Item' does not match the expected CIDR format (example:  192.168.0.0/24)"
            }
        }
        'country' {
            if ($Item -notmatch '^(AF|AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BQ|BA|BW|BV|BR|IO|BN|BG|BF|BI|KH|CM|CA|CV|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CW|CY|CZ|DK|DJ|DM|DO|EC|EG|SV|GQ|ER|EE|ET|FK|FO|FJ|FI|FR|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|VA|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MK|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|RE|RO|RU|RW|BL|SH|KN|LC|MF|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SX|SK|SI|SB|SO|ZA|GS|SS|ES|LK|SD|SR|SJ|SZ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UM|UY|UZ|VU|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$') {
                throw "Country code '$Item' does not match the expected country code format (example: US)"
            }
        }
        'asn' {
            if ($Item -notmatch '^(AS\d+)$') {
                throw "ASN '$Item' does not match the expected ASN format (example: AS1234)"
            }
        }
        default {
            throw 'How did we get here?'
        }
    }

    # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Add-CFFirewallRule: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }

    # If we specified a zone earlier, create the access rules there, else, do it at a user level
    if (-not ([string]::IsNullOrEmpty($ZoneID))) {
        Write-Verbose "Add-CFFirewallRule: Targeting only $($Script:ZoneName) for this firewall rule."
        $Data = @{
            'mode' = $Mode
            'notes' = $Notes
            'configuration' = @{
                'value' = $Item
                'target' = $Target
            }
            'group' = @{
                'id' = 'zone'
            }
        }
        $Uri = $Script:APIURI + ('/zones/{0}/firewall/access_rules/rules' -f $ZoneID)
    }
    else {
        Write-Verbose "Add-CFFirewallRule: Targeting entire organization for this firewall rule."
        $Data = @{
            'mode' = $Mode
            'notes' = $Notes
            'configuration' = @{
                'value' = $Item
                'target' = $Target
            }
            'group' = @{
                'id' = 'owner'
            }
        }
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules')
    }
    
    Write-Verbose "Add-CFFirewallRule: URI = '$Uri'"

    try {
        Write-Verbose -Message "Add-CFFirewallRule: Adding '$Item' as '$Target' in '$Mode' mode..."

        Set-CFRequestData -Uri $Uri -Body $Data -Method 'Post'
        $Response = Invoke-CFAPI4Request -ErrorAction Stop
    }
    catch {
        Throw $_
    }
}




Function Connect-CFClientAPI {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Connect-CFClientAPI.md
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




Function Get-CFCurrentZone {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Get-CFCurrentZone.md
    #>
    return $Script:Zone
}




Function Get-CFCurrentZoneID {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Get-CFCurrentZoneID.md
    #>
    return $Script:ZoneID
}




Function Get-CFFirewallRule {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Get-CFFirewallRule.md
    #>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID
    )  
    
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Get-CFFirewallRulePage: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }
    
    # Get the first page, from there we will be able to see the total page numbers
    try {
        $LatestPage = Get-CFFirewallRulePage -ZoneID $ZoneID -PageNumber 1 -ErrorAction Stop
        $result = $LatestPage.result
        $TotalPages = $LatestPage.result_info.total_pages
    }
    catch {
        throw $_
    }

    $PageNumber = 2
    
    # Get any more pages
    while ($PageNumber -le $TotalPages) {
        try {
            $LatestPage = Get-CFFirewallRulePage -ZoneID $ZoneID -PageNumber $PageNumber -ErrorAction Stop
            $result += $LatestPage.result
            $PageNumber++
        }
        catch {
            throw $_
            break
        }
    }

    $result
}




Function Get-CFRequestData {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Get-CFRequestData.md
    #>
    return $Script:RESTParams
}




Function Get-CFZoneID {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Get-CFZoneID.md
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




Function Invoke-CFAPI4Request {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Invoke-CFAPI4Request.md
    #>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [Uri]$Uri = ($Script:RESTParams).URI,
       
        [Parameter()]
        [HashTable]$Headers = ($Script:RESTParams).Headers,

        [Parameter()]
        [Hashtable]$Body =  ($Script:RESTParams).Body,

        [Parameter()]
        [String]$Method =  ($Script:RESTParams).Method
    )

    if ($Uri -eq $null) {
        throw 'Need to run Set-CFRequestData first!'
    }
    $BodyData = if ($Body -eq $null) {$null} else { if ($Method -ne 'Get') {$Body | ConvertTo-Json} else {$Body}}


    try {
        $JSONResponse = Invoke-RestMethod -Uri $Uri -Headers $Headers -ContentType 'application/json' -Method $Method -Body $BodyData -ErrorAction Stop
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




Function Remove-CFFirewallRule {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Remove-CFFirewallRule.md
    #>

    Param (
        [Parameter(Mandatory = $True)]
        [ValidateScript({
            ($_ -match '^[a-f0-9]{32}$')
        })]
        [String]$RuleID,

        [Parameter()]
        [ValidateScript({
            IsNullOrCFID $_
        })]
        [String]$ZoneID
    )   
    
    # If the ZoneID is empty see if we have loaded one earlier in the module and use it instead.
    if ([string]::IsNullOrEmpty($ZoneID) -and ($Script:ZoneID -ne $null)) {
        Write-Verbose "Remove-CFFirewallRule: No ZoneID was passed but the current targeted zone was $($Script:ZoneName) so this will be used."
        $ZoneID = $Script:ZoneID
    }

    # URI will change if we specified a DNS zone or not
    if (-not ([string]::IsNullOrEmpty($ZoneID))) {
        $Uri = $Script:APIURI +('/zones/{0}/firewall/access_rules/rules/{1}' -f $ZoneID, $RuleID)
    }
    else {
        $Uri = $Script:APIURI + ('/user/firewall/access_rules/rules/{0}' -f $RuleID)
    }

    Set-CFRequestData -Uri $Uri -Method 'Delete'
    
    try {
        Write-Verbose -Message 'Attempting to remove firewall rule...'
        $Response = Invoke-CFAPI4Request -ErrorAction Stop
    }
    catch {
        Throw $_
    }
}




Function Set-CFCurrentZone {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Set-CFCurrentZone.md
    #>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [String]$Zone
    )

    if ([string]::IsNullOrEmpty($Zone)) {
        Write-Verbose -Message ('Set-CFCurrentZone: Unsetting the targetted DNS zone.')
        $Script:ZoneID = $null
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




Function Set-CFRequestData {
<#
    .EXTERNALHELP PSCloudFlare-help.xml
    .LINK
        https://github.com/zloeber/PSCloudFlare/tree/master/release/0.0.2/docs/Set-CFRequestData.md
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




## Post-Load Module code ##


# Use this variable for any path-sepecific actions (like loading dlls and such) to ensure it will work in testing and after being built
$MyModulePath = $(
    Function Get-ScriptPath {
        $Invocation = (Get-Variable MyInvocation -Scope 1).Value
        if($Invocation.PSScriptRoot) {
            $Invocation.PSScriptRoot
        }
        Elseif($Invocation.MyCommand.Path) {
            Split-Path $Invocation.MyCommand.Path
        }
        elseif ($Invocation.InvocationName.Length -eq 0) {
            (Get-Location).Path
        }
        else {
            $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"));
        }
    }

    Get-ScriptPath
)


#region Module Cleanup
$ExecutionContext.SessionState.Module.OnRemove = {
    # Action to take if the module is removed
}

$null = Register-EngineEvent -SourceIdentifier ( [System.Management.Automation.PsEngineEvent]::Exiting ) -Action {
    # Action to take if the whole pssession is killed
}
#endregion Module Cleanup

# Exported members
#Export-ModuleMember -Variable SomeVariable -Function  *




