#!/bin/sh

curl -X GET "localhost:9200/_cat/nodes?v&pretty"

exit 0
