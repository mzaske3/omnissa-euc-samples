# Description: Set Registry Key
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Timeout: 120
# Variables: None

$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
$servicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"
$valueName = "AvailableUpdates"

try {

    # ------------------------------------------------
    # 1. Validate Secure Boot Enabled
    # ------------------------------------------------
    $secureBootEnabled = $false

    try {
        if (Confirm-SecureBootUEFI -ErrorAction Stop) {
            $secureBootEnabled = $true
        }
    }
    catch {
        try {
            $sbReg = Get-ItemProperty -Path "$regPath\State" -Name "UEFISecureBootEnabled" -ErrorAction Stop
            if ($sbReg.UEFISecureBootEnabled -eq 1) {
                $secureBootEnabled = $true
            }
        }
        catch { }
    }

    if (-not $secureBootEnabled) { exit 0 }

    # ------------------------------------------------
    # 2. Validate Supported Windows Version
    # ------------------------------------------------
    $osReg = Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion" -ErrorAction Stop
    $build = [int]$osReg.CurrentBuild

    # Windows 10 22H2 build = 19045
    # Windows 11 builds >= 22000
    if ($build -lt 19045) { exit 0 }

    # ------------------------------------------------
    # 3. Do Not Modify if Already Updated
    # ------------------------------------------------
    try {
        $servicing = Get-ItemProperty -Path $servicingPath -Name "UEFICA2023Status" -ErrorAction Stop
        if ($servicing.UEFICA2023Status -eq "Updated") {
            exit 0
        }
    }
    catch { }

    # ------------------------------------------------
    # 4. Validate AvailableUpdates Exists
    # ------------------------------------------------
    $reg = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
    if ($null -eq $reg.$valueName) { exit 0 }

    $currentValue = [int]$reg.$valueName

    # ------------------------------------------------
    # 5. Stage Update Only if Value = 0
    # ------------------------------------------------
    if ($currentValue -eq 0) {

        # 0x5944 = 22852 decimal
        $newValue = 22852

        Set-ItemProperty -Path $regPath -Name $valueName -Value $newValue -Type DWord -ErrorAction Stop
    }

}
catch {
    # Silent for Workspace ONE execution
}

exit 0