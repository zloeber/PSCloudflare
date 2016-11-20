#Requires -Version 5
param (
    [switch]$BuildModule,
    [switch]$CreatePSGalleryProfile,
    [switch]$UpdateRelease,
    [switch]$UploadPSGallery,
    [switch]$GitCheckin,
    [switch]$GitPush,
    [switch]$InstallAndTestModule,
    [version]$NewVersion,
    [string]$ReleaseNotes
)

# Install InvokeBuild module if it doesn't already exist
if ((get-module InvokeBuild -ListAvailable) -eq $null) {
    Write-Host -NoNewLine "      Installing InvokeBuild module"
    $null = Install-Module InvokeBuild
    Write-Host -ForegroundColor Green '...Installed!'
}
if (get-module InvokeBuild -ListAvailable) {
    Write-Host -NoNewLine "      Importing InvokeBuild module"
    Import-Module InvokeBuild -Force
    Write-Host -ForegroundColor Green '...Loaded!'
}
else {
    throw 'How did you even get here?'
}

# Create a gallery profile?
if ($CreatePSGalleryProfile) {
    try {
        Invoke-Build NewPSGalleryProfile
    }
    catch {
        throw 'Unable to create the .psgallery profile file!'
    }
}

# Update your release version?
if ($UpdateRelease) {
    if ($NewVersion -ne $null) {
        $NewVersion.ToString() | Out-File -FilePath .\version.txt -Force
    }

    try {
        Invoke-Build UpdateVersion
    }
    catch {
        throw
    }
}

# If no parameters were specified or the build action was manually specified then kick off a standard build
if (($psboundparameters.count -eq 0) -or ($BuildModule))  {
    try {
        Invoke-Build
    }
    catch {
        Write-Host -ForegroundColor Red 'Build Failed with the following error:'
        Write-Output $_
    }
}

# Install and test the module?
if ($InstallAndTestModule) {
    try {
        Invoke-Build InstallAndTestModule
    }
    catch {
        Write-Host -ForegroundColor Red 'Install and test of module failed:'
        Write-Output $_
    }
}

# Upload to gallery?
if ($UploadPSGallery) {
    if ([string]::IsNullOrEmpty($ReleaseNotes)) {
        throw '$ReleaseNotes needs to be specified to run this operation!'
    }
    try {
        Invoke-Build PublishPSGallery -ReleaseNotes $ReleaseNotes
    }
    catch {
        throw 'Unable to upload projec to the PowerShell Gallery!'
    }
}

# Not implemented yet
if ($GitCheckin) {

}

# Not implemented yet
if ($GitPush) {

}

Write-Host ''
Write-Host 'Attempting to clean up the session (loaded modules and such)...'
Invoke-Build BuildSessionCleanup
Remove-Module InvokeBuild
