
# Dot-source the Apache-Logs.ps1 file
. .\Apache-Logs.ps1

# Call the function and store the results
$filteredLogs = Parse-ApacheLogs

# Display the results in a readable format
if ($filteredLogs) {
    Write-Output "Filtered Apache Logs for 10.* Network:"
    $filteredLogs | Format-Table -AutoSize -Wrap
} else {
    Write-Output "No matching logs found."
}
