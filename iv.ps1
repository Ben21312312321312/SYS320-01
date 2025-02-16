Deliverable #4: 
# Import the function that gathers the class data
. .\gatherClasses.ps1 

# Fetch class data
$FullTable = gatherClasses

# Group instructors by number of classes they are teaching, sorted in descending order
Write-Output "-------------------------------------"
Write-Output "Instructors grouped by number of classes they are teaching (sorted descending):"
Write-Output "-------------------------------------"

$FullTable | Group-Object "Instructor" | 
Sort-Object Count -Descending | 
Format-Table Count, Name -AutoSize
