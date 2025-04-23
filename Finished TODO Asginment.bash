#!/bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){
    echo -n "Please Input an Instructor Full Name: "
    read instName
    echo ""
    echo "Courses of $instName :"
    cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | sed 's/;/ | /g'
    echo ""
}

function courseCountofInsts(){
    echo ""
    echo "Course-Instructor Distribution"
    cat "$courseFile" | cut -d';' -f7 | grep -v "/" | grep -v "\.\.\." | sort -n | uniq -c | sort -n -r 
    echo ""
}

#  TODO-1: Display courses in a classroom
function displayCoursesofRoom(){
    echo -n "Please Input a Class Name (e.g., JOYC 310): "
    read room
    echo ""
    echo "Courses in $room :"
    grep "$room" "$courseFile" | cut -d';' -f1,2,5,6,7 | sed 's/;/ | /g'
    echo ""
}

#  TODO-2: Display courses with availability for a subject
function displayAvailableCoursesOfSubject(){
    echo -n "Please Input a Subject Name (e.g., SEC): "
    read subject
    echo ""
    echo "Available courses in $subject :"
    awk -F';' -v sub="$subject" '$1 ~ "^"sub && $3 > 0 { print $0 }' "$courseFile" | sed 's/;/ | /g'
    echo ""
}

while :
do
    echo ""
    echo "Please select and option:"
    echo "[1] Display courses of an instructor"
    echo "[2] Display course count of instructors"
    echo "[3] Display courses of a classroom"
    echo "[4] Display available courses of subject"
    echo "[5] Exit"

    read userInput
    echo ""

    case "$userInput" in
        1) displayCoursesofInst ;;
        2) courseCountofInsts ;;
        3) displayCoursesofRoom ;;
        4) displayAvailableCoursesOfSubject ;;
        5) echo "Goodbye"; break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
