# Description: Validates BitLocker protection status on system drive.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Unknown"

try {
    $bl = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
    if ($bl.ProtectionStatus -eq 1) {
        $result = "Healthy"
    } else {
        $result = "NotHealthy"
    }
}
catch { }

Write-Output $result
