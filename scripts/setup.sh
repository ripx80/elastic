#!/bin/sh

set -e -o pipefail

HOST=localhost

put(){
    curl --user elastic:changeme -X PUT "$HOST:9200/$1" -H 'Content-Type: application/json' -d "
    $2
    "
}

post(){
    curl --user elastic:changeme -X POST "$HOST:9200/$1" -H 'Content-Type: application/json' -d "
    $2
    "
}



# set system params
sysctl -w vm.max_map_count=262144





# create passwords

docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url https://es01:9200"




# setup kibana
curl -X POST http://localhost:5601/api/saved_objects/index-pattern/system  -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '
{
  "attributes": {
    "title": "system*"
  }
}'



exit 0
