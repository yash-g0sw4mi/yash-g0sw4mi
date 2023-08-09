#!/bin/bash

read -p "Enter the target URL: " url

echo "Starting directory fuzzing on $url..."
ffuf -u "$url/FUZZ" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -c -o ffuf_dir_report.txt

if grep -q "200 OK" ffuf_dir_report.txt; then
    echo "Directory found. Starting directory fuzzing again..."
    ffuf -u "$url/FUZZ" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -c -o ffuf_dir_report_2.txt
fi

read -p "Do you want to perform parameter fuzzing? (y/n): " param_fuzz_choice

if [ "$param_fuzz_choice" = "y" ] || [ "$param_fuzz_choice" = "Y" ]; then
    read -p "Use default parameter wordlist? (y/n): " param_wordlist_choice
    
    if [ "$param_wordlist_choice" = "n" ] || [ "$param_wordlist_choice" = "N" ]; then
        read -p "Enter the path to your custom parameter wordlist: " custom_param_wordlist
        ffuf -u "$url?FUZZ=VALUE" -w "$custom_param_wordlist" -c -o ffuf_param_report.txt
    else
        ffuf -u "$url?FUZZ=VALUE" -w /path/to/default/parameter/wordlist.txt -c -o ffuf_param_report.txt
    fi

    if grep -q "200 OK" ffuf_param_report.txt; then
        read -p "Parameter found. Enter the path to your fuzzing wordlist for files: " custom_file_wordlist
        ffuf -u "$url/FUZZ" -w "$custom_file_wordlist" -c -o ffuf_file_report.txt
    else
        echo "No valid parameter found. Skipping file fuzzing."
    fi
fi

echo "Fuzzing completed."

