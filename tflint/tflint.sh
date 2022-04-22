#!/bin/bash

set -e

GREEN_COLOR="\033[1;32m"
YELLOW_COLOR="\033[1;33m"
NO_COLOR="\033[0m"

echo -e "${GREEN_COLOR}TFLint Scanning terraform/shared.... $NO_COLOR"
cd terraform/shared
tflint --config=../../tflint/.tflint.hcl --loglevel=info
if [[ $? -eq 0 ]]
then
    echo -e "${YELLOW_COLOR}No issues found in terraform/shared.$NO_COLOR"
fi
cd ../../
echo -e "\n"

for folder in terraform/environment/*
do
    cd $folder
    echo -e "${GREEN_COLOR}TFLint Scanning $folder....$NO_COLOR"
    tflint --config=../../../tflint/.tflint.hcl --loglevel=info
    if [[ $? -eq 0 ]]
    then
        echo -e "${YELLOW_COLOR}No issues found in $folder.$NO_COLOR"
    fi
    cd ../../../
    echo -e "\n"
done;