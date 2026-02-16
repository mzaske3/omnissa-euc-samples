# Description: Returns the Secure Boot AvailableUpdates registry value to monitor update staging and bit clearing progress.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: INTEGER

$result = -1

try {
    $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot" -Name "AvailableUpdates" -ErrorAction Stop
    if ($null -ne $reg.AvailableUpdates) {
        $result = [int]$reg.AvailableUpdates
    }
}
catch { }

Write-Output $result