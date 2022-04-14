#!/bin/bash

# Terrascan scan and save output to scan_results
terrascan scan --use-colors -t > scan_results

# Get scan summary from scan_results
scan_summary=$(cat scan_results | sed -n -e '/Scan Summary -/,$p')

#Extract values from scan_summary
low_level_violations=$(grep "Low" <<< "$scan_summary" | grep -o -E "[0-9]+")
medium_level_violations=$(grep "Medium" <<< "$scan_summary" | grep -o -E "[0-9]+")
high_level_violations=$(grep "High" <<< "$scan_summary" | grep -o -E "[0-9]+") 

#Show Scan Output
cat scan_results

#Remove scan_results
rm scan_results

#Check for violations
if [[ $high_level_violations -gt 0 ]]
then
    echo "High Level Voilations Found"
    exit 1
fi
echo "No Violations found"
exit 0
