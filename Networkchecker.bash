#!/bin/bash

myIP=$(bash myIP.bash)

# Help Menu Function
function helpmenu(){
  echo ""
  echo "     HELP MENU"
  echo "    ------------"
  echo "-n: Add -n as an argument for this script to use nmap"
  echo "   external: External NMAP scan"
  echo "   internal: Internal NMAP scan"
  echo "-s: Add -s as an argument for this script to use ss"
  echo "   external: External ss (Netstat) scan"
  echo "   internal: Internal ss (Netstat) scan"
  echo ""
  echo "Usage: bash $0 -n/-s external/internal"
  echo "------------"
}

# External NMAP Scan
function ExternalNmap(){
  nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1, $4}'
}

# Internal NMAP Scan
function InternalNmap(){
  nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1, $4}'
}

# External SS Listening Ports
function ExternalListeningPorts(){
  ss -ltpn | awk -F"[[:space:]:(),]+" '!/127.0.0./ && /LISTEN/ {print $5, $9}' | tr -d "\""
}

# Internal SS Listening Ports
function InternalListeningPorts(){
  ss -ltpn | awk -F"[[:space:]:(),]+" '/127.0.0./ && /LISTEN/ {print $5, $9}' | tr -d "\""
}

# Check argument count
if [ $# -ne 2 ]; then
  helpmenu
  exit 1
fi

# Parse options
while getopts ":n:s:" opt; do
  case $opt in
    n)
      if [[ $OPTARG == "external" ]]; then
        ExternalNmap
      elif [[ $OPTARG == "internal" ]]; then
        InternalNmap
      else
        helpmenu
      fi
      ;;
    s)
      if [[ $OPTARG == "external" ]]; then
        ExternalListeningPorts
      elif [[ $OPTARG == "internal" ]]; then
        InternalListeningPorts
      else
        helpmenu
      fi
      ;;
    \?)
      helpmenu
      ;;
  esac
done
