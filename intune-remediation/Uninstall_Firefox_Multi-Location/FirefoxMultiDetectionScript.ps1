####### Detection script ########
## Detection Script to check if Firefox is installed in any location or if any leftover files remains
## Author: Ahad Alam
## Date: 10-April-2025


$Detected = $false
$LocalUsers = (Get-ChildItem -Path "C:\Users" -Directory).Name

# Check Program Files
if (Test-Path "${env:ProgramFiles(x86)}\Mozilla Firefox\uninstall\helper.exe") {
    Write-Output "Firefox detected in ProgramFiles (x86)"
    $Detected = $true
}
if (Test-Path "${env:ProgramFiles}\Mozilla Firefox\uninstall\helper.exe") {
    Write-Output "Firefox detected in ProgramFiles"
    $Detected = $true
}

# Check user-specific locations
foreach ($LocalUser in $LocalUsers) {
    $UserPath = "C:\Users\$LocalUser"

    if (Test-Path "$UserPath\AppData\Local\Mozilla Firefox\uninstall\helper.exe") {
        Write-Output "Firefox detected in $UserPath\AppData\Local"
        $Detected = $true
    }

    if (Test-Path "$UserPath\AppData\Local\Mozilla") {
        Write-Output "Mozilla folder detected in $UserPath\AppData\Local"
        $Detected = $true
    }

    if (Test-Path "$UserPath\AppData\LocalLow\Mozilla") {
        Write-Output "Mozilla folder detected in $UserPath\AppData\LocalLow"
        $Detected = $true
    }

    if (Test-Path "$UserPath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk") {
        Write-Output "Firefox shortcut detected in Start Menu for $LocalUser"
        $Detected = $true
    }

    if (Test-Path "$UserPath\Desktop\firefox.lnk") {
        Write-Output "Firefox shortcut detected on desktop for $LocalUser"
        $Detected = $true
    }
}

# Check common registry keys and global Start Menu shortcut
$pathsToCheck = @(
'HKLM:\Software\Mozilla',
'HKLM:\SOFTWARE\mozilla.org',
'HKLM:\SOFTWARE\MozillaPlugins',
'HKLM:\SOFTWARE\WOW6432Node\Mozilla',
'HKLM:\SOFTWARE\WOW6432Node\mozilla.org',
'HKLM:\SOFTWARE\WOW6432Node\MozillaPlugins',
'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk'
)

foreach ($path in $pathsToCheck) {
    if (Test-Path $path) {
        Write-Output "Firefox-related registry key or shortcut detected: $path"
        $Detected = $true
    }
}

# Final exit based on detection
if ($Detected) {
    exit 1
} else {
    exit 0
}
