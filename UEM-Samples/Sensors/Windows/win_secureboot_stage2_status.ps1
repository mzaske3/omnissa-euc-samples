# Description: Returns Secure Boot CA 2023 servicing status.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "NotPresent"

try {
    $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -Name "UEFICA2023Status" -ErrorAction Stop
    if ($reg.UEFICA2023Status) {
        $result = $reg.UEFICA2023Status
    }
}
catch { }

Write-Output $result
