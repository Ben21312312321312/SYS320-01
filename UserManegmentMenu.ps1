# Clear the screen
Clear-Host

# ================================
# Functions for Local User Management
# ================================

function getEnabledUsers {
    $enabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "True" } | Select-Object Name, SID
    return $enabledUsers
}

function getNotEnabledUsers {
    $notEnabledUsers = Get-LocalUser | Where-Object { $_.Enabled -ilike "False" } | Select-Object Name, SID
    return $notEnabledUsers
}

function createAUser($name, $password) {
    $params = @{
        Name     = $name
        Password = $password
    }
    $newUser = New-LocalUser @params 

    # Policies:
    # Force the user to change password
    Set-LocalUser $newUser -PasswordNeverExpires $false
    # Newly created users are disabled by default
    Disable-LocalUser $newUser
}

function removeAUser($name) {
    $userToBeDeleted = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    Remove-LocalUser $userToBeDeleted
}

function disableAUser($name) {
    $userToBeDisabled = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    Disable-LocalUser $userToBeDisabled
}

function enableAUser($name) {
    $userToBeEnabled = Get-LocalUser | Where-Object { $_.Name -ilike $name }
    Enable-LocalUser $userToBeEnabled
}

# ================================
# Functions for Event Log Parsing
# ================================

function getLogInAndOffs($timeBack) {
    $loginEvents = Get-EventLog system -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays("-" + "$timeBack")
    $loginoutsTable = @()
    
    for ($i = 0; $i -lt $loginEvents.Count; $i++) {
        $type = ""
        if ($loginEvents[$i].InstanceID -eq 7001) { $type = "Logon" }
        if ($loginEvents[$i].InstanceID -eq 7002) { $type = "Logoff" }
        
        # Translate the SID into a user name
        $user = (New-Object System.Security.Principal.SecurityIdentifier $loginEvents[$i].ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])
        
        $loginoutsTable += [pscustomobject]@{
            "Time"  = $loginEvents[$i].TimeGenerated
            "Id"    = $loginEvents[$i].InstanceId
            "Event" = $type
            "User"  = $user
        }
    }
    return $loginoutsTable
}

function getFailedLogins($timeBack) {
    $failedEvents = Get-EventLog security -After (Get-Date).AddDays("-" + "$timeBack") | Where-Object { $_.InstanceID -eq "4625" }
    $failedLoginsTable = @()
    
    for ($i = 0; $i -lt $failedEvents.Count; $i++) {
        # Extract account name and domain from the message using getMatchingLines function
        $usrLines = getMatchingLines $failedEvents[$i].Message "*Account Name*"
        $usr = $usrLines[1].Split(":")[1].Trim()
        
        $dmnLines = getMatchingLines $failedEvents[$i].Message "*Account Domain*"
        $dmn = $dmnLines[1].Split(":")[1].Trim()
        
        $user = $dmn + "\" + $usr
        
        $failedLoginsTable += [pscustomobject]@{
            "Time"  = $failedEvents[$i].TimeGenerated
            "Id"    = $failedEvents[$i].InstanceId
            "Event" = "Failed"
            "User"  = $user
        }
    }
    return $failedLoginsTable
}

# ================================
# String Helper Function
# ================================

function getMatchingLines($contents, $lookline) {
    $allLines = @()
    $splitted = $contents -split [Environment]::NewLine
    
    for ($j = 0; $j -lt $splitted.Count; $j++) {
        if ($splitted[$j].Length -gt 0) {
            if ($splitted[$j] -ilike $lookline) {
                $allLines += $splitted[$j]
            }
        }
    }
    return $allLines
}

# ================================
# Main Menu Code
# ================================

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Exit`n"

$operation = $true

while ($operation) {
    Write-Host $Prompt | Out-String
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        "1" {
            $enabledUsers = getEnabledUsers
            Write-Host ($enabledUsers | Format-Table | Out-String)
        }
        "2" {
            $notEnabledUsers = getNotEnabledUsers
            Write-Host ($notEnabledUsers | Format-Table | Out-String)
        }
        "3" {
            $name = Read-Host -Prompt "Please enter the username for the new user"
            $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

            # TODO: Validate the username using a checkUser function (if implemented)
            # TODO: Validate the password using a checkPassword function (if implemented)

            createAUser $name $password
            Write-Host "User: $name is created."
        }
        "4" {
            $name = Read-Host -Prompt "Please enter the username for the user to be removed"
            # TODO: Validate the username using the checkUser function
            removeAUser $name
            Write-Host "User: $name removed."
        }
        "5" {
            $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
            # TODO: Validate the username using the checkUser function
            enableAUser $name
            Write-Host "User: $name enabled."
        }
        "6" {
            $name = Read-Host -Prompt "Please enter the username for the user to be disabled"
            # TODO: Validate the username using the checkUser function
            disableAUser $name
            Write-Host "User: $name disabled."
        }
        "7" {
            $name = Read-Host -Prompt "Please enter the username for the user logs"
            # TODO: Validate the username using the checkUser function
            # TODO: Optionally prompt the user for the number of days (currently hardcoded as 90)
            $userLogins = getLogInAndOffs 90
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name" } | Format-Table | Out-String)
        }
        "8" {
            $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
            # TODO: Validate the username using the checkUser function
            # TODO: Optionally prompt the user for the number of days (currently hardcoded as 90)
            $userLogins = getFailedLogins 90
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name" } | Format-Table | Out-String)
        }
        "9" {
            Write-Host "Goodbye"
            exit
        }
        Default {
            Write-Host "Invalid option. Please enter a number between 1 and 9."
        }
    }
}
