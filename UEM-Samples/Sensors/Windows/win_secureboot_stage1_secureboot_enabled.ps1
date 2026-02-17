# Description: Checks if Secure Boot is enabled and system is UEFI.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Legacy BIOS"

try {
    $sb = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -ErrorAction Stop
    if ($sb.UEFISecureBootEnabled -eq 1) {
        $result = "Enabled"
    } else {
        $result = "Disabled"
    }
}
catch { }

Write-Output $result
