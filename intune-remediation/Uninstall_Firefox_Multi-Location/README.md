# 🦊 Uninstall Firefox from Multiple Locations

This detection and remediation script pair is designed to identify and fully uninstall Mozilla Firefox from a Windows device, including residual files, shortcuts, registry entries, and Microsoft Store installations.

---

## 📂 Files

- `FirefoxMultiDetectionScript.ps1`  
  Detects Firefox installations or traces across system-wide and user-specific locations.

- `FirefoxMultiRemediationScript.ps1`  
  Silently uninstalls Firefox from all detected locations and cleans up associated leftovers.

---

## 🔍 Detection Logic

The detection script looks for:

- Standard installation directories:
  - `C:\Program Files\Mozilla Firefox`
  - `C:\Program Files (x86)\Mozilla Firefox`

- Per-user AppData paths:
  - `%LOCALAPPDATA%\Mozilla Firefox`
  - `%APPDATA%\Mozilla Firefox`
  - LocalLow directories
  - Desktop and Start Menu shortcuts

- Global Start Menu shortcuts

- Registry keys:
  - `HKLM:\Software\Mozilla`
  - `HKLM:\Software\WOW6432Node\Mozilla`
  - `HKLM:\Software\MozillaPlugins`, etc.

- Microsoft Store installs via `Get-AppxPackage -Name "Mozilla.Firefox*"`

📌 Exit codes:
- `1`: Firefox or remnants found
- `0`: Firefox not detected

---

## 🧹 Remediation Logic

The remediation script:

- Uninstalls Firefox using `helper.exe` in standard and user-local install paths
- Deletes:
  - `%LOCALAPPDATA%\Mozilla`
  - `%APPDATA%\Mozilla Firefox`
  - `%APPDATA%\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk`
  - `%USERPROFILE%\Desktop\firefox.lnk`

- Removes Firefox-related registry keys under both native and WOW6432Node hives
- Uninstalls Firefox if found via Microsoft Store

🛡️ Runs safely across all user profiles present on the machine.

---

## 🚀 Intune Deployment Instructions

Follow these steps to deploy the scripts via Microsoft Intune:

1. ✅ Download both `.ps1` files.  
   Uploading them directly helps maintain encoding integrity—avoid browser-based editing.

2. 📁 In the Intune Admin Center:
   - Navigate to:  
     `Devices` → `Manage devices` → `Scripts and remediations`
   - Select **Create script package**

3. 📝 In the Basics step:
   - Name the script package
   - Optionally provide a Description
   - Publisher defaults to your name
   - Version is auto-generated

4. ⚙️ In the Settings step:
   - Upload both script files using the folder icon:
     - Detection script: `FirefoxMultiDetectionScript.ps1`
     - Remediation script: `FirefoxMultiRemediationScript.ps1`

   - Set the following options:
     - **Run this script using the logged-on credentials**: No
     - **Enforce script signature check**: No
     - **Run script in 64-bit PowerShell**: Yes

5. 🏷️ Scope tags (optional):
   - Assign tags as needed.

6. 🎯 Assignments:
   - Select the device groups to which you want to deploy the script package.
   - When you're ready to deploy the packages to your users or devices, you can also use filters.

7. 📦 Review and Create:
   - Confirm your settings and create the script package.

---

## ✅ Requirements

- Windows 10/11 - 64-bit
- PowerShell 5.1 or later

---

## 🧑‍💻 Author

Created and maintained by **Ahad Alam**  
GitHub: [@Ahad621](https://github.com/Ahad621)  
Cloud & Systems Engineer | Automation | DevOps

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](../../../LICENSE) file for details.
