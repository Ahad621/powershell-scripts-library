####### Remediation script ########
## Remediation Script to remove Firefox (and all leftover files) from all the locations
## Author: Ahad Alam
## Date: 10-April-2025


$LocalUsers = (Get-ChildItem -Path "C:\Users").name

# Uninstalling from Program Files
if (Test-Path "${env:ProgramFiles(x86)}\Mozilla Firefox\uninstall\helper.exe"){
    Start-Process -FilePath "${env:ProgramFiles(x86)}\Mozilla Firefox\uninstall\helper.exe" -ArgumentList '/S' -Verbose -ErrorAction SilentlyContinue
}

if (Test-Path "${env:ProgramFiles}\Mozilla Firefox\uninstall\helper.exe"){
    Start-Process -FilePath "${env:ProgramFiles}\Mozilla Firefox\uninstall\helper.exe" -ArgumentList '/S' -Verbose -ErrorAction SilentlyContinue
}

# Uninstalling for each user
ForEach ($LocalUser in $LocalUsers){
    $Userpath = "C:\Users\" + $LocalUser

    if (Test-Path "$Userpath\AppData\Local\Mozilla Firefox\uninstall\helper.exe"){
        Start-Process -FilePath "$Userpath\AppData\Local\Mozilla Firefox\uninstall\helper.exe" -ArgumentList '/S' -Verbose -ErrorAction SilentlyContinue
    }
    Start-Sleep 20

    # Remove shortcuts from appdata
    Remove-Item -Path "$userpath\AppData\Local\Mozilla" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    Remove-Item -Path "$userpath\AppData\LocalLow\Mozilla" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    Remove-Item -Path "$userpath\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk" -Force -Verbose -ErrorAction SilentlyContinue
    Remove-Item -Path "$userpath\desktop\firefox.lnk" -Force -Verbose -ErrorAction SilentlyContinue
}
    # Remove related registry keys
    $pathToRemove = @(
    'HKLM:\Software\Mozilla'
    'HKLM:\SOFTWARE\mozilla.org'
    'HKLM:\SOFTWARE\MozillaPlugins'
    'HKLM:\SOFTWARE\WOW6432Node\Mozilla'
    'HKLM:\SOFTWARE\WOW6432Node\mozilla.org'
    'HKLM:\SOFTWARE\WOW6432Node\MozillaPlugins'
    'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk'
    )

    foreach($path in $pathToRemove) {
        if(Test-Path $path) {
            try {
                Remove-Item $path -Recurse -Force -Verbose -ErrorAction SilentlyContinue
            }
            catch {
                    Write-Warning $_.Exception.Message
            }
        }
}
