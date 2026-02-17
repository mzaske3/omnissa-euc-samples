# Description: Returns Secure Boot CA 2023 error code if firmware rejected update.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: INTEGER

$result = -1

try {
    $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -Name "UEFICA2023Error" -ErrorAction Stop
    if ($null -ne $reg.UEFICA2023Error) {
        $result = [int]$reg.UEFICA2023Error
    }
}
catch { }

Write-Output $result
