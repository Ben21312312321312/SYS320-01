# Import the function that gathers the class data
. .\gatherClasses.ps1 

# Fetch class data
$FullTable = gatherClasses

# List all the classes of JOYC 310 on Mondays, sorted by Start Time
Write-Output "-------------------------------------"
Write-Output "Classes of JOYC 310 on Mondays, Sorted by Start Time:"
Write-Output "-------------------------------------"

$FullTable | Where-Object { $_.Location -eq "JOYC 310" -and $_.Days -like "*Monday*" } | 
Sort-Object "Time Start" | 
Format-Table "Time Start", "Time End", "Class Code" -AutoSize
