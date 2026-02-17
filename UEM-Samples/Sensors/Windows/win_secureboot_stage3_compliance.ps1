# Description: Determines authoritative Secure Boot CA 2023 compliance state using defensive registry validation.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$result = "Non-Compliant"

try {

    $sbKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State"

    if (-not (Test-Path $sbKeyPath)) { Write-Output $result; exit 0 }

    $sbKey = Get-ItemProperty -Path $sbKeyPath -ErrorAction Stop

    if (-not $sbKey.PSObject.Properties.Name.Contains("UEFISecureBootEnabled")) { Write-Output $result; exit 0 }

    if ([int]$sbKey.UEFISecureBootEnabled -ne 1) { Write-Output $result; exit 0 }

    $servicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"

    if (-not (Test-Path $servicingPath)) { Write-Output $result; exit 0 }

    $servicing = Get-ItemProperty -Path $servicingPath -ErrorAction Stop

    if (-not $servicing.PSObject.Properties.Name.Contains("UEFICA2023Status")) { Write-Output $result; exit 0 }

    $statusValue = $servicing.UEFICA2023Status.ToString().Trim()

    if ($statusValue -ne "Updated") { Write-Output $result; exit 0 }

    $errorValue = $null

    if ($servicing.PSObject.Properties.Name.Contains("UEFICA2023Error")) {
        $errorValue = $servicing.UEFICA2023Error
    }

    if ($null -eq $errorValue -or [int]$errorValue -eq 0) {
        $result = "Compliant"
    }

}
catch { }

Write-Output $result