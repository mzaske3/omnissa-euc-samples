# Description: One final safety check to determine if the system is ready
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: String

$result = "Unsupported OS"

try {

    # ------------------------------------------------
    # 1. Detect VM (avoid firmware staging on VMs)
    # ------------------------------------------------
    try {
        $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
        if ($cs.Model -match "Virtual|VMware|VirtualBox|KVM|Hyper-V") {
            $result = "Virtual Machine"
            Write-Output $result
            exit 0
        }
    } catch { }

    # ------------------------------------------------
    # 2. Validate UEFI + Secure Boot (Registry Only)
    # ------------------------------------------------
    try {
        $sbReg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -ErrorAction Stop
        if ($sbReg.UEFISecureBootEnabled -ne 1) {
            $result = "Secure Boot Disabled"
            Write-Output $result
            exit 0
        }
    }
    catch {
        $result = "Legacy BIOS"
        Write-Output $result
        exit 0
    }

    # ------------------------------------------------
    # 3. Validate Supported OS
    # ------------------------------------------------
    $osReg = Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion" -ErrorAction Stop
    $build = [int]$osReg.CurrentBuild

    if ($build -lt 19045) {
        $result = "Unsupported OS"
        Write-Output $result
        exit 0
    }

    # ------------------------------------------------
    # 4. Validate BitLocker Health
    # ------------------------------------------------
    try {
        $bl = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
        if ($bl.ProtectionStatus -ne 1) {
            $result = "BitLocker Not Healthy"
            Write-Output $result
            exit 0
        }
    }
    catch {
        # If BitLocker cmdlet unavailable, do not block
    }

    # ------------------------------------------------
    # 5. Check Secure Boot Servicing State
    # ------------------------------------------------
    try {
        $servicing = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -ErrorAction Stop

        if ($servicing.UEFICA2023Status -eq "Updated") {
            $result = "Already Updated"
            Write-Output $result
            exit 0
        }

        if ($null -ne $servicing.UEFICA2023Error -and $servicing.UEFICA2023Error -ne 0) {
            $result = "Update Error Detected"
            Write-Output $result
            exit 0
        }
    }
    catch { }

    # ------------------------------------------------
    # 6. Validate AvailableUpdates Exists
    # ------------------------------------------------
    try {
        $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot" -Name "AvailableUpdates" -ErrorAction Stop
        if ($null -eq $reg.AvailableUpdates) {
            $result = "Needs BIOS Review"
            Write-Output $result
            exit 0
        }
    }
    catch {
        $result = "Needs BIOS Review"
        Write-Output $result
        exit 0
    }

    # ------------------------------------------------
    # 7. Default Ready State
    # ------------------------------------------------
    $result = "Ready"

}
catch {
    $result = "Unsupported OS"
}

Write-Output $result