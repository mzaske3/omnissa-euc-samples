# Description: Returns BIOS firmware version for Secure Boot diagnostics.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Unknown"

try {
    $bios = Get-CimInstance Win32_BIOS -ErrorAction Stop
    if ($bios.SMBIOSBIOSVersion) {
        $result = $bios.SMBIOSBIOSVersion
    }
}
catch { }

Write-Output $result
