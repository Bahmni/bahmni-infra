#!/bin/bash
scan_summary=$(cat scan_results | sed -n -e '/Scan Summary -/,$p')

low_level_violations=$(grep "Low" <<< "$scan_summary" | grep -o -E "[0-9]+")
medium_level_violations=$(grep "Medium" <<< "$scan_summary" | grep -o -E "[0-9]+")
high_level_violations=$(grep "High" <<< "$scan_summary" | grep -o -E "[0-9]+") 

if [[ $high_level_violations -gt 0 ]]
then
    echo "High Level Voilations Found"
    exit 1
fi
echo "No Violations found"
exit 0
