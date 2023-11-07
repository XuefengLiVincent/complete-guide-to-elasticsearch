#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: alias-local-index.sh local-url index-name alias-name"
    echo "alias the local index @ local-url/index-name to alias-name"
    exit 1
fi

set -o xtrace

curl -XPUT "$1/$2/_aliases" -H 'content-type: application/json' -d'
{
   "actions": [
   	{
      "add": {
        "index": '\"${2}\"',
        "alias": '\"${3}\"'
      }
	  }
  ]
}'

echo "$2 aliased as $3"
