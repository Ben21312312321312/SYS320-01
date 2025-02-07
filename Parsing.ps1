function Get-LogIPs {
    # Inputs hardcoded based on the requirements
    $Page = "page1.html"       # Page visited or referred from
    $HttpCode = "404"          # HTTP code returned
    $BrowserName = "Chrome"    # Name of the web browser

    # Read Apache log file
    $logs = Get-Content "C:\xampp\apache\logs\access.log"

    # Filter logs based on inputs
    $filteredLogs = $logs | Where-Object {
        ($_ -match $Page) -and ($_ -match $HttpCode) -and ($_ -match $BrowserName)
    }

    # Define a regex for IP addresses
    $regex = [regex]"\b(?:\d{1,3}\.){3}\d{1,3}\b"

    # Extract IP addresses
    $ips = foreach ($line in $filteredLogs) {
        if ($regex.IsMatch($line)) {
            $regex.Match($line).Value
        }
    }

    # Return unique IPs
    return $ips | Sort-Object -Unique
}

# Execute function when script runs directly
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Name) {
    Write-Output "IP Addresses matching criteria (Page: page1.html, HTTP Code: 404, Browser: Chrome):"
    Get-LogIPs
}
