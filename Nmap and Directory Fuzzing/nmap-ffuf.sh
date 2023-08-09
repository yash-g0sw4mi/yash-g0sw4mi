#!/bin/bash

target=""
read -p "Enter the target IP address or domain: " target

function run_nmap_scan() {
    nmap_args=("nmap" "-p" "80,443" "-sV" "-Pn" "$1")
    nmap_output=$( "${nmap_args[@]}" )
    echo "$nmap_output"
}

function fuzz_directories() {
    ffuf_args=("ffuf" "-w" "/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" "-u" "$1/FUZZ" "-c" "-o" "ffuf_report.txt")
    "${ffuf_args[@]}"
}

nmap_output=$(run_nmap_scan "$target")
echo "$nmap_output"

if echo "$nmap_output" | grep -q "80/tcp"; then
    url="http://$target:80"
    echo "Starting directory fuzzing on port 80..."
    fuzz_directories "$url"
else
    echo "Port 80 is not open. No directory fuzzing needed."
fi

