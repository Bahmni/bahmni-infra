#!/bin/bash

# set -e
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the errors eg. in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
set -o xtrace

SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
SCRIPT_DIRECTORY=$(dirname "$SCRIPT_PATH")
GREEN_COLOR="\033[1;32m"
YELLOW_COLOR="\033[1;33m"
NO_COLOR="\033[0m"

run_validate(){
    folder=$1
    cd $folder
    if [[ $GITHUB_ACTIONS ]]
    then
        terraform init -backend=false
    fi
    
    echo -e "${GREEN_COLOR}Terrafom Validating $folder....$NO_COLOR"
    terraform validate -json

    if [[ $? -eq 0 ]]
    then
        echo -e "${YELLOW_COLOR}No issues found in $folder.$NO_COLOR"
    fi

    cd - > /dev/null
    echo -e "\n"
}

run_validate terraform/shared
for folder in terraform/environment/*
do
    run_validate $folder
done;

for folder in terraform/modules/*
do
    run_validate $folder
done;