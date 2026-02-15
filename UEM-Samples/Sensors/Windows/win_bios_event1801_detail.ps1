# Description: Windows Event Log Event ID 1801 details 
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "No Event 1801 Found"

try {
    $start = (Get-Date).AddDays(-60)

    $event = Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        Id      = 1801
        StartTime = $start
    } -MaxEvents 1 -ErrorAction Stop

    if ($event -and $event.Message) {
        # Remove line breaks for clean UEM output
        $cleanMessage = ($event.Message -replace "`r`n"," " -replace "`n"," ").Trim()
        $result = $cleanMessage
    }
}
catch { }

Write-Output $result