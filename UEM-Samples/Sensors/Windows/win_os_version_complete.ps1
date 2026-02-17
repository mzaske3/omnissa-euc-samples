# Description: Combine OS Name, Display Version, and Build Number into a single string. For example 
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Unknown"

try {
    $regPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion"
    $reg = Get-ItemProperty -Path $regPath -ErrorAction Stop

    $build = [int]$reg.CurrentBuild
    $ubr = $reg.UBR
    $displayVersion = $reg.DisplayVersion
    if (-not $displayVersion) { $displayVersion = $reg.ReleaseId }

    $edition = $reg.EditionID

    # Determine OS name by build
    if ($build -ge 22000) {
        $osName = "Windows 11"
    } else {
        $osName = "Windows 10"
    }

    if ($edition -and $build -and $ubr) {
        $result = "$osName $edition - $displayVersion (10.0.$build.$ubr)"
    }
}
catch { }

Write-Output $result