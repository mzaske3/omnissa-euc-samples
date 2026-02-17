# Description: Returns Secure Boot CA 2023 update completion timestamp if available.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "NotAvailable"

try {
    $event = Get-WinEvent -FilterHashtable @{LogName='System'; Id=1808} -MaxEvents 1 -ErrorAction Stop
    if ($event) {
        $result = $event.TimeCreated.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
}
catch { }

Write-Output $result
