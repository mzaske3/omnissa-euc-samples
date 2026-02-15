# Description: Windows Event Log Event ID 1808 to show current status of certificates
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Secure Boot certificates not detected"

try {
    $start = (Get-Date).AddDays(-60)

    $event = Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        Id      = 1808
        StartTime = $start
    } -MaxEvents 1 -ErrorAction Stop

    if ($event) {
        $timestamp = $event.TimeCreated.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        $result = "Secure Boot certificates have been applied as of $timestamp"
    }
}
catch { }

Write-Output $result