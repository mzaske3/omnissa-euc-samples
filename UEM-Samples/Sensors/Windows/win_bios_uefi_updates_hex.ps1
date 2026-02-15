# Description: This is the bitmask flag to determine current servicing state. Examples 0X0 means nothing is staged, 0x5944 means DB update staging requested. 
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "None"

try {
    $reg = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot" -Name AvailableUpdates -ErrorAction Stop
    if ($null -ne $reg.AvailableUpdates) {
        $result = "0x{0:X}" -f $reg.AvailableUpdates
    }
}
catch { }

Write-Output $result