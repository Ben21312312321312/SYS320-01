# Import the function that gathers the class data
. .\gatherClasses.ps1 

# Fetch class data
$FullTable = gatherClasses

# List unique instructors teaching at least one course in SYS, NET, SEC, FOR, CSI, DAT
Write-Output "-------------------------------------"
Write-Output "Instructors teaching at least 1 course in SYS, NET, SEC, FOR, CSI, DAT:"
Write-Output "-------------------------------------"

$ITSInstructors = $FullTable | 
Where-Object { $_."Class Code" -match "^(SYS|NET|SEC|FOR|CSI|DAT)" } | 
Select-Object -ExpandProperty "Instructor" -Unique | 
Sort-Object 

$ITSInstructors | Format-Table -AutoSize
