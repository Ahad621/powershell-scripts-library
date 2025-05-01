####### Remediation script ########
## Remediation Script to remove Firefox (and all leftover files) from all the locations
## Author: Ahad Alam
## Date: 10-April-2025


$LocalUsers = (Get-ChildItem -Path "C:\Users" -Directory).Name

# Function to uninstall Firefox from a given path
function Uninstall-Firefox {
    param ([string]$Path)
    if (Test-Path "$Path\uninstall\helper.exe") {
        Write-Output "Attempting to uninstall Firefox from: $Path"
        Start-Process -FilePath "$Path\uninstall\helper.exe" -ArgumentList '/S' -Wait -ErrorAction SilentlyContinue
    }
}

# Uninstall from common program locations
Uninstall-Firefox "${env:ProgramFiles(x86)}\Mozilla Firefox"
Uninstall-Firefox "${env:ProgramFiles}\Mozilla Firefox"

# Uninstall from each user’s local AppData
foreach ($LocalUser in $LocalUsers) {
    $UserPath = "C:\Users\$LocalUser"
    $LocalInstall = "$UserPath\AppData\Local\Mozilla Firefox"
    $RoamingInstall = "$UserPath\AppData\Roaming\Mozilla Firefox"

    Uninstall-Firefox $LocalInstall
    Uninstall-Firefox $RoamingInstall

    Start-Sleep -Seconds 10

    # Remove Mozilla folders
    Remove-Item "$UserPath\AppData\Local\Mozilla" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
    Remove-Item "$UserPath\AppData\LocalLow\Mozilla" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
    Remove-Item "$UserPath\AppData\Roaming\Mozilla Firefox" -Recurse -Force -Verbose -ErrorAction SilentlyContinue

    # Remove Firefox shortcuts
    Remove-Item "$UserPath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk" -Force -Verbose -ErrorAction SilentlyContinue
    Remove-Item "$UserPath\Desktop\firefox.lnk" -Force -Verbose -ErrorAction SilentlyContinue
}

# Remove global shortcuts and registry traces
$pathsToRemove = @(
'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk',
'HKLM:\Software\Mozilla',
'HKLM:\Software\mozilla.org',
'HKLM:\Software\MozillaPlugins',
'HKLM:\Software\WOW6432Node\Mozilla',
'HKLM:\Software\WOW6432Node\mozilla.org',
'HKLM:\Software\WOW6432Node\MozillaPlugins'
)

foreach ($path in $pathsToRemove) {
    if (Test-Path $path) {
        try {
            Remove-Item $path -Recurse -Force -Verbose -ErrorAction SilentlyContinue
        } catch {
            Write-Warning $_.Exception.Message
        }
    }
}

# Uninstall Firefox if installed from the Microsoft Store
$StoreApp = Get-AppxPackage -Name "Mozilla.Firefox*"
if ($StoreApp) {
    Write-Output "Uninstalling Firefox installed via Microsoft Store"
    Remove-AppxPackage -Package $StoreApp.PackageFullName
}
