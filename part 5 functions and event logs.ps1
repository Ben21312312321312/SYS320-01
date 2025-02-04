# Define a function to get start and shutdown events
function Get-StartShutdownEvents {
    param (
        [int]$Days  # Number of days to retrieve logs for
    )

    # Define the Event IDs for start and shutdown
    $eventIds = 6005, 6006  # 6005: System Start, 6006: System Shutdown

    # Get start and shutdown events from the System log
    $events = Get-WinEvent -FilterHashtable @{
        LogName = "System";
        StartTime = (Get-Date).AddDays(-$Days);
        Id = $eventIds
    }

    # Initialize an array to store the formatted results
    $startShutdownTable = @()

    # Process each event and create a custom object for output
    foreach ($event in $events) {
        # Determine the Event type (Start or Shutdown)
        $eventType = switch ($event.Id) {
            6005 { "System Start" }
            6006 { "System Shutdown" }
            default { "Unknown" }
        }

        # Add the event details to the output table
        $startShutdownTable += [PSCustomObject]@{
            Time  = $event.TimeCreated
            Id    = $event.Id
            Event = $eventType
            User  = "System"  # Constant value
        }
    }

    # Return the formatted results
    return $startShutdownTable | Sort-Object Time
}

# Call the function with a parameter (e.g., logs for the last 14 days) and print the results
$results = Get-StartShutdownEvents -Days 14
$results | Format-Table -AutoSize
