function Parse-ApacheLogs {
    # Read the Apache log file
    $logPath = "C:\xampp\apache\logs\access.log"
    if (-Not (Test-Path $logPath)) {
        Write-Host "Log file not found at $logPath"
        return
    }

    $logsNotFormatted = Get-Content $logPath
    $tableRecords = @()

    foreach ($line in $logsNotFormatted) {
        # Split a string into words
        $words = $line -split " "

        # Ensure the line contains enough elements before proceeding
        if ($words.Count -lt 12) { continue }

        # Add a custom object for each log entry
        $tableRecords += [PSCustomObject]@{
            "IP"        = $words[0]
            "Time"      = $words[3].TrimStart("[").TrimEnd("]")
            "Method"    = $words[5].Trim('"')
            "Page"      = $words[6]
            "Protocol"  = $words[7].Trim('"')
            "Response"  = $words[8]
            "Referrer"  = $words[10].Trim('"')
            "Client"    = $words[11].Trim('"')
        }
    }

    # Filter records for IPs in the 10.* network
    return $tableRecords | Where-Object { $_.IP -like "10.*" }
}
