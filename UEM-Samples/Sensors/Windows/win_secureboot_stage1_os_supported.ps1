# Description: Validates supported OS build for Secure Boot CA 2023 update.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Unsupported"

try {
    $reg = Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion" -ErrorAction Stop
    $build = [int]$reg.CurrentBuild

    if ($build -ge 19045) {
        $result = "Supported"
    }
}
catch { }

Write-Output $result
