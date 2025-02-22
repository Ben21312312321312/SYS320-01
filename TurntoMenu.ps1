# Dot-source the external script files so their functions become available.
. .\ParsingApacheLogs.ps1        # Contains function ApacheLogs1
. .\LocalUserManagement.ps1       # Contains functions getFailedLogins and DisplayAtRiskUsers

# Function to display the menu
function Show-Menu {
    Write-Host "============================="
    Write-Host "Select an option:"
    Write-Host "1. Display last 10 Apache logs"
    Write-Host "2. Display last 10 failed logins for all users"
    Write-Host "3. Display at risk users"
    Write-Host "4. Start Chrome web browser and navigate to champlain.edu"
    Write-Host "5. Exit"
    Write-Host "============================="
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-5)"

    # Validate that input is a number between 1 and 5.
    if ($choice -match '^[1-5]$') {
        switch ($choice) {
            1 {
                Write-Host "Displaying the last 10 Apache logs..."
                ApacheLogs1
            }
            2 {
                Write-Host "Displaying the last 10 failed logins for all users..."
                getFailedLogins
            }
            3 {
                Write-Host "Displaying at risk users..."
                DisplayAtRiskUsers
            }
            4 {
                Write-Host "Attempting to start Chrome..."
                # Check if any instances of Chrome are running.
                $chromeProcess = Get-Process chrome -ErrorAction SilentlyContinue
                if ($null -eq $chromeProcess) {
                    # Start Chrome and navigate to champlain.edu.
                    Start-Process "chrome.exe" "http://champlain.edu"
                }
                else {
                    Write-Host "Chrome is already running."
                }
            }
            5 {
                Write-Host "Exiting program. Goodbye!"
            }
        }
    }
    else {
        Write-Host "Invalid option. Please enter a number between 1 and 5."
    }

    Write-Host ""  # Blank line for readability.
} while ($choice -ne "5")
