# Description: Current version of the SecureBoot firmware 
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Unknown"

try {
    $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing\DeviceAttributes" -Name FirmwareVersion -ErrorAction Stop
    if (![string]::IsNullOrWhiteSpace($reg.FirmwareVersion)) {
        $result = $reg.FirmwareVersion
    }
}
catch { }

Write-Output $result