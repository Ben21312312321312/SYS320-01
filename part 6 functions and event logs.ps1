function Get-StartShutdownEvents {
    param ([int]$Days)

    # Define the Event IDs for startup and shutdown
    $eventIds = 6005, 6006  # Startup (6005) and Shutdown (6006)

    # Retrieve events
    Write-Host "Querying System log for the last $Days days..." -ForegroundColor Yellow
    $events = Get-WinEvent -FilterHashtable @{
        LogName = "System";
        StartTime = (Get-Date).AddDays(-$Days);
        Id = $eventIds
    }

    Write-Host "Retrieved $($events.Count) events from the System log" -ForegroundColor Green

    # Initialize an array to store the formatted results
    $startShutdownTable = @()

    foreach ($event in $events) {
        Write-Host "Processing Event ID: $($event.Id), Time: $($event.TimeCreated)" -ForegroundColor Cyan

        # Determine the Event type
        $eventType = switch ($event.Id) {
            6005 { "Startup" }
            6006 { "Shutdown" }
            default { "Unknown" }
        }

        # Add the event details to the table
        $startShutdownTable += [PSCustomObject]@{
            Time  = $event.TimeCreated
            Id    = $event.Id
            Event = $eventType
            User  = "System"  # Constant value
        }
    }

    if ($startShutdownTable.Count -eq 0) {
        Write-Host "No startup or shutdown events found in the System log." -ForegroundColor Red
    }

    # Return the table
    return $startShutdownTable | Sort-Object Time
}

# Test the function
$results = Get-StartShutdownEvents -Days 30
$results | Format-Table -AutoSize
