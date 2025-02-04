# Define the Event IDs for Logon and Logoff
$eventIds = 4624, 4634, 7001, 7002  # Include relevant Logon and Logoff event IDs

# Get logon and logoff events from the Security log for the last 14 days
$events = Get-WinEvent -FilterHashtable @{
    LogName = "Security";
    StartTime = (Get-Date).AddDays(-14);
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

    # Extract the user information (handle ReplacementStrings if needed)
    $user = if ($event.Properties.Count -ge 5) {
        $event.Properties[5].Value
    } else {
        "Unknown"
    }

    # Add the event details to the output table
    $loginoutsTable += [PSCustomObject]@{
        Time  = $event.TimeCreated
        Id    = $event.Id
        Event = $eventType
        User  = $user
    }
}

# Display the results
$loginoutsTable | Sort-Object Time | Format-Table -AutoSize
