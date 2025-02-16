# Import the function that gathers the class data
. .\gatherClasses.ps1 

# Fetch class data
$FullTable = gatherClasses

# List all the classes taught by Furkan Paligu
Write-Output "-------------------------------------"
Write-Output "Classes taught by Furkan Paligu:"
Write-Output "-------------------------------------"

$FullTable | Where-Object { $_.Instructor -eq "Furkan Paligu" } | 
Format-Table "Class Code", "Instructor", "Location", "Days", "Time Start", "Time End" -AutoSize
