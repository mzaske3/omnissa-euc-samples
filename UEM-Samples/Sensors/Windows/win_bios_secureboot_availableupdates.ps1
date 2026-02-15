# Description: Display the registry value AvailableUpdates which will then be used to determine the script to run to remediate
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: Integer

$result = -1

try {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
    $reg = Get-ItemProperty -Path $regPath -Name "AvailableUpdates" -ErrorAction Stop

    if ($null -ne $reg.AvailableUpdates) {
        $result = [int]$reg.AvailableUpdates
    }
}
catch { }

Write-Output $result
