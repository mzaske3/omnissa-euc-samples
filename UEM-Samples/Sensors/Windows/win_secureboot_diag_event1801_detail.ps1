# Description: Returns most recent Event ID 1801 message for Secure Boot diagnostics.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "No Event 1801 Found"

try {
    $event = Get-WinEvent -FilterHashtable @{LogName='System'; Id=1801} -MaxEvents 1 -ErrorAction Stop
    if ($event -and $event.Message) {
        $result = ($event.Message -replace "`r`n"," " -replace "`n"," ").Trim()
    }
}
catch { }

Write-Output $result
