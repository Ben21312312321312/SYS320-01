#!/bin/bash

# FUNCTIONS

function displayAllLogs() {
    cat /var/log/apache2/access.log
}

function displayOnlyIPS() {
    cat /var/log/apache2/access.log | cut -d ' ' -f1 | sort | uniq
}

function displayOnlyPages() {
    cat /var/log/apache2/access.log | cut -d ' ' -f7 | sort | uniq
}

function frequentVisitors() {
    cat /var/log/apache2/access.log | cut -d ' ' -f1 | sort | uniq -c | sort -nr | head
}

function suspiciousVisitors() {
    grep -f ioc.txt /var/log/apache2/access.log | cut -d ' ' -f1 | sort | uniq -c
}

# MENU LOOP

while true
do
    echo ""
    echo "Please select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPS"
    echo "[3] Display only Pages"
    echo "[4] Histogram"
    echo "[5] Frequent Visitors"
    echo "[6] Suspicious Visitors"
    echo "[7] Quit"
    read -p "Enter option: " choice

    case $choice in
        1) displayAllLogs ;;
        2) displayOnlyIPS ;;
        3) displayOnlyPages ;;
        4) echo "Feature not implemented yet." ;;
        5) frequentVisitors ;;
        6) suspiciousVisitors ;;
        7) echo "Goodbye!"; break ;;
        *) echo "Invalid option, please try again." ;;
    esac
done
