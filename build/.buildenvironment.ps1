# Update these to suit your PowerShell module build. These variables get dot sourced into 
# the build at every run. The path root of the locations are assumed to be at the root of the 
# PowerShell module project directory.

# NOTE: The first variables are the most important. All the other are a matter of preference

# The module we are building
#   Example: 'FormatPowerShellCode'
$ModuleToBuild = 'PSCloudFlare'

# Project website (used for external help cab file definition) 
# Example: 'https://github.com/zloeber/FormatPowershellCode' 
$ModuleWebsite = 'https://github.com/zloeber/PSCloudFlare'

# Some tags that describe your module. 
# Example: @('Code Formatting', 'Module Creation', 'Build Scripts')
$ModuleTags = @('Cloudflare','API')

# Module Author
$ModuleAuthor = 'Zachary Loeber'

# Module Author
$ModuleDescription = 'Cloudflare API PowerShell wrapper module'

# Options - These affect how your eventual build will be run.
$OptionFormatCode = $false
$OptionAnalyzeCode = $true
$OptionCombineFiles = $true
$OptionTranscriptEnabled = $false
$OptionTranscriptLogFile = 'BuildTranscript.Log'

# PlatyPS has been the cause of most of my build failures. This can help you isolate which functrion's CBH is causing you grief.
$OptionRunPlatyPSVerbose = $false

# Additional paths in the source module which should be copied over to the final build release
# Example: @('.\libs','.\data')
$AdditionalModulePaths = @()

# If you will be attempting to autogenerate comment based help this is the base template that will be used
# You need to leave the %%<string>%% tags to automatically be populated.
$CBHTemplate = @'
<#
.SYNOPSIS
    TBD
.DESCRIPTION
    TBD
%%PARAMETER%%
.EXAMPLE
    TBD
.NOTES
    Author: %%AUTHOR%%
.LINK
    %%LINK%%
#>
'@ -replace '%%LINK%%',$ModuleWebsite -replace '%%AUTHOR%%',$ModuleAuthor

########################################
# !! Please leave anything below this line alone !!
########################################

# Ensure we bomb out if any required information is missing
$ModuleToBuild, $ModuleWebsite, $ModuleAuthor, $ModuleDescription | Foreach {
    if ([string]::IsNullOrEmpty($_)) {
        Write-Error 'You must first define all of the environment variables in .buildenvironment.ps1!'
    }
}
if ($ModuleTags.Count -eq 0) {
    Write-Error 'You must first assign a few tags to your module in .buildenvironment.ps1!'
}

# Update module tags to replace spaces with underscores
for ($i = 0; $i -lt $ModuleTags.Count; $i++) {
    $ModuleTags[$i] = $ModuleTags[$i] -replace ' ','_' 
}