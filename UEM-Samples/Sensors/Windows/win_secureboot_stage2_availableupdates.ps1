# Description: Returns AvailableUpdates bitmask to monitor staging and reboot progress.
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
