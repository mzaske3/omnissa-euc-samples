# Description: This will determine if Secure Boot is enabled. Safe to run on both UEFI and non-UEFI systems.
# Execution Context: SYSTEM
# Execution Architecture: 64-bit
# Return Type: STRING

$secureBootState = "Unsupported"

try {
    $status = Confirm-SecureBootUEFI -ErrorAction Stop

    if ($status -eq $true) {
        $secureBootState = "Enabled"
    }
    elseif ($status -eq $false) {
        $secureBootState = "Disabled"
    }
}
catch {
    # Non-UEFI system or Secure Boot not supported
    $secureBootState = "Unsupported"
}

Write-Output $secureBootState
exit 0