# Description: Determine if the UEFI Certificates are updated
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "NotAvailable"

try {
    $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -Name UEFICA2023Status -ErrorAction Stop
    if ([string]::IsNullOrWhiteSpace($reg.UEFICA2023Status)) {
        $result = "Unknown"
    } else {
        $result = $reg.UEFICA2023Status
    }
}
catch { }

Write-Output $result