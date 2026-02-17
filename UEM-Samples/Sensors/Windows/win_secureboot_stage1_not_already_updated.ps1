# Description: Detects whether Secure Boot CA 2023 update already applied.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "NotUpdated"

try {
    $servicing = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -ErrorAction Stop
    if ($servicing.UEFICA2023Status -eq "Updated") {
        $result = "AlreadyUpdated"
    }
}
catch { }

Write-Output $result
