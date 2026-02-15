# Description: Is the system secureboot compliant 
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Non-Compliant"

try {
    # ----------------------------
    # 1. Check Secure Boot State
    # ----------------------------
    $secureBootEnabled = $false

    try {
        $sb = Confirm-SecureBootUEFI -ErrorAction Stop
        if ($sb -eq $true) {
            $secureBootEnabled = $true
        }
    }
    catch {
        # Fallback to registry
        try {
            $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -Name UEFISecureBootEnabled -ErrorAction Stop
            if ($reg.UEFISecureBootEnabled -eq 1) {
                $secureBootEnabled = $true
            }
        }
        catch { }
    }

    # ----------------------------
    # 2. Check Event 1808 (Cert Applied)
    # ----------------------------
    $eventFound = $false

    if ($secureBootEnabled) {

        $start = (Get-Date).AddDays(-90)

        $event = Get-WinEvent -FilterHashtable @{
            LogName = 'System'
            Id      = 1808
            StartTime = $start
        } -MaxEvents 1 -ErrorAction SilentlyContinue

        if ($event) {
            $eventFound = $true
        }
    }

    # ----------------------------
    # 3. Final Compliance Decision
    # ----------------------------
    if ($secureBootEnabled -and $eventFound) {
        $result = "Compliant"
    }
}
catch { }

Write-Output $result