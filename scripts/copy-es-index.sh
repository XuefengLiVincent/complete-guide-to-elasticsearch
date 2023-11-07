#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: copy-es-index.sh src-url des-url src-index des-index"
    echo "copy the index from src-url to des-url"
    exit 1
fi

set -o xtrace
NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=$1/$3 --output=$2/$4 --type=analyzer

curl -k -XPUT "$2/$4/_settings" -H 'content-type: application/json' -d'
{
   "index.mapping.total_fields.limit": 5000,
   "index.max_result_window": 50000
}'

NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=$1/$3 --output=$2/$4 --type=mapping

# adding this prompt to short-circuit data loading in case other index updates need to happen,
# like adding new fields/properties, etc. before data is loaded
# TODO - break out data loading as a standalone script so that it can be run without the other steps
read -p "Would you like to go ahead with copying the data from ${1}/${3} to ${2}/${4}?(Y|n) [n]? " copyPrompt
if [[ "$copyPrompt" != "Y" ]]; then
    echo "empty index created at ${2}/${4}"
    exit 0;
else
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=$1/$3 --output=$2/$4 --type=data --limit 1000
  echo "$3 copied from $1 to $2."
fi
