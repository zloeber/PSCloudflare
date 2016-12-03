Function IsCFID ([string]$ID) {
    if (-not ([string]::IsNullOrEmpty($ID))) {
        return ($ID -match '^[a-f0-9]{32}$')
    }
    else {
        return $false
    }
}