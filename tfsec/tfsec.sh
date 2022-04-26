#!/bin/bash

set -e
SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
SCRIPT_DIRECTORY=$(dirname "$SCRIPT_PATH")
GREEN_COLOR="\033[1;32m"
YELLOW_COLOR="\033[1;33m"
NO_COLOR="\033[0m"

run_scan(){
    folder=$1

    cd $folder
    if [[ $GITHUB_ACTIONS ]]
    then
        terraform init -backend=false
    fi

    echo -e "${GREEN_COLOR}TFSec Scanning $folder....$NO_COLOR"
    tfsec --config-file $SCRIPT_DIRECTORY/tfsec.yml --tfvars-file=terraform.tfvars --verbose

    cd - > /dev/null
    echo -e "\n"
}

run_scan terraform/shared
for folder in terraform/environment/*
do
    run_scan $folder
done;
