#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: copy-to-local-es-index.sh src-url src-index des-index"
    echo "copy the index from src-url to local ES"
    exit 1
fi

set -o xtrace
LOCAL_URL="http://localhost:9400"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

"${SCRIPT_DIR}"/copy-es-index.sh "${1}" "${LOCAL_URL}" "${2}" "${3}"

if [[ "${2}" != "${3}" ]]; then
    read -p "Would you like to alias ${3} as ${2}?(Y|n) [n]? " aliasPrompt
    if [[ "$aliasPrompt" != "Y" ]]; then
        exit 0;
    else
        "${SCRIPT_DIR}"/alias-local-index.sh "${LOCAL_URL}" "${3}" "${2}"
    fi
fi
