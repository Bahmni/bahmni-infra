#!/bin/bash
export TFLINT_LOG=debug
set -e
REL_SCRIPT_DIR="`dirname \"$0\"`"
SCRIPT_DIR="`( cd \"$REL_SCRIPT_DIR\" && pwd)`"
# sourcing git hub actions common script
source $SCRIPT_DIR/../.github/gha_common.sh
TFLINT_IMAGE="ghcr.io/terraform-linters/tflint"
REPO_ROOT="`cd \"$SCRIPT_DIR/..\" && pwd`"

run_scan(){
    folder=$1

    cd $folder
    terraform_init
    cd - > /dev/null

    target_dir="`cd \"$folder\" && pwd`"

    echo -e "${GREEN_COLOR}TFLint Scanning $folder....$NO_COLOR"
    # Run init and lint in the same container invocation so the plugin
    # cache (/root/.tflint.d) populated by --init is still present for
    # the actual lint run (each `docker run` is otherwise a fresh container).
    docker run --rm --entrypoint sh \
        -v "$REPO_ROOT":"$REPO_ROOT" \
        -w "$target_dir" \
        "$TFLINT_IMAGE" \
        -c "tflint --config=$SCRIPT_DIR/.tflint.hcl --init && tflint --config=$SCRIPT_DIR/.tflint.hcl"

    if [[ $? -eq 0 ]]
    then
        echo -e "${YELLOW_COLOR}No issues found in $folder.$NO_COLOR"
    fi

    echo -e "\n"
}

run_scan terraform/
for folder in terraform/node_groups/*
do
    run_scan $folder
done;
