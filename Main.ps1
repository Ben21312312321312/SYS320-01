# Dot-source the Apache-Logs.ps1 file
. .\Apache-Logs.ps1

# Call the function with the specified inputs
$result = Get-LogIPs -Page "page1.html" -HttpCode "404" -BrowserName "Chrome"

# Display the result
Write-Output "IP Addresses matching criteria (Page: page1.html, HTTP Code: 404, Browser: Chrome):"
$result
