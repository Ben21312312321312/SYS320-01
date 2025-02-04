# Define a function to get logon and logoff events
function Get-LogonLogoffEvents {
    param (
        [int]$Days  # Number of days to retrieve logs for
    )

    # Define the Event IDs for Logon and Logoff
    $eventIds = 4624, 4634, 7001, 7002  # Relevant Event IDs

    # Get logon and logoff events from the Security log
    $events = Get-WinEvent -FilterHashtable @{
        LogName = "Security";
        StartTime = (Get-Date).AddDays(-$Days);
        Id = $eventIds
    }

    # Initialize an array to store the formatted results
    $loginoutsTable = @()

    # Process each event and create a custom object for output
    foreach ($event in $events) {
        # Determine the Event type (Logon or Logoff)
        $eventType = switch ($event.Id) {
            4624 { "Logon" }
            7001 { "Logon" }
            4634 { "Logoff" }
            7002 { "Logoff" }
            default { "Unknown" }
        }

        # Extract the user information from Properties (SID or account name)
        $rawUser = if ($event.Properties.Count -gt 5) {
            $event.Properties[5].Value
        } else {
            "Unknown"
        }

        # Translate SID to username if the rawUser looks like a SID
        $user = if ($rawUser -match "^S-1-") {
            try {
                $sid = New-Object System.Security.Principal.SecurityIdentifier($rawUser)
                $account = $sid.Translate([System.Security.Principal.NTAccount])
                $account.Value
            } catch {
                $rawUser  # Fall back to raw value if translation fails
            }
        } else {
            $rawUser  # Use raw value if it's already a username
        }

        # Add the event details to the output table
        $loginoutsTable += [PSCustomObject]@{
            Time  = $event.TimeCreated
            Id    = $event.Id
            Event = $eventType
            User  = $user
        }
    }

    # Return the formatted results
    return $loginoutsTable | Sort-Object Time
}

# Call the function with a parameter (e.g., logs for the last 14 days) and print the results
$results = Get-LogonLogoffEvents -Days 14
$results | Format-Table -AutoSize

