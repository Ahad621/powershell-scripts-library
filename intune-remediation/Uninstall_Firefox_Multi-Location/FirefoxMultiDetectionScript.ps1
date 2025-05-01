####### Detection script ########
## Detection Script to check if Firefox is installed in any location or if any leftover files remain
## Author: Ahad Alam
## Date Created: 10-April-2025
## Date Modified: 15-April-2025


$Detected = $false
$LocalUsers = (Get-ChildItem -Path "C:\Users" -Directory).Name

$Logs = @()

# Function to check if Firefox is installed in a given path
function Check-Firefox {
    param ([string]$Path)
    if (Test-Path "$Path\uninstall\helper.exe") {
        $Logs += "Firefox detected at: $Path"
        $script:Detected = $true
    }
}

# Check common install locations
Check-Firefox "${env:ProgramFiles(x86)}\Mozilla Firefox"
Check-Firefox "${env:ProgramFiles}\Mozilla Firefox"

# Check each user’s local AppData
foreach ($LocalUser in $LocalUsers) {
    $UserPath = "C:\Users\$LocalUser"
    $LocalInstall = "$UserPath\AppData\Local\Mozilla Firefox"
    $RoamingInstall = "$UserPath\AppData\Roaming\Mozilla Firefox"

    Check-Firefox $LocalInstall
    Check-Firefox $RoamingInstall

    if (Test-Path "$UserPath\AppData\Local\Mozilla") {
        $Logs += "Mozilla folder found in AppData\Local for $LocalUser"
        $Detected = $true
    }

    if (Test-Path "$UserPath\AppData\LocalLow\Mozilla") {
        $Logs += "Mozilla folder found in AppData\LocalLow for $LocalUser"
        $Detected = $true
    }

    if (Test-Path "$UserPath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk") {
        $Logs += "Firefox shortcut found in Start Menu for $LocalUser"
        $Detected = $true
    }

    if (Test-Path "$UserPath\Desktop\firefox.lnk") {
        $Logs += "Firefox shortcut found on desktop for $LocalUser"
        $Detected = $true
    }
}

# Check if Firefox is installed via Microsoft Store
$StoreApp = Get-AppxPackage -Name "Mozilla.Firefox*"  # Look for any installed version of Firefox
if ($StoreApp) {
    $Logs += "Firefox detected via Microsoft Store"
    $Detected = $true
}

# Check registry entries and global shortcut
$pathsToCheck = @(
'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk',
'HKLM:\Software\Mozilla',
'HKLM:\Software\mozilla.org',
'HKLM:\Software\MozillaPlugins',
'HKLM:\Software\WOW6432Node\Mozilla',
'HKLM:\Software\WOW6432Node\mozilla.org',
'HKLM:\Software\WOW6432Node\MozillaPlugins'
)

foreach ($path in $pathsToCheck) {
    if (Test-Path $path) {
        $Logs += "Detected Firefox-related entry: $path"
        $Detected = $true
    }
}

# Final exit
if ($Detected) {
    Write-Output -InputObject ($Logs -join ', ')
    exit 1
} else {
    Write-Output "Firefox is not Detected."
    exit 0
}
