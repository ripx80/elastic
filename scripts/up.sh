#!/bin/bash

set -e
set -o pipefail

FLUENTBIT="https://fluentbit.io/releases/1.6/fluent-bit-1.6.2.tar.gz"
FLUENTBIT_SHA="https://fluentbit.io/releases/1.6/fluent-bit-1.6.2.tar.gz.md5"

FLUENTBIT_WIN="https://fluentbit.io/releases/1.6/td-agent-bit-1.6.2-win64.zip"
FLUENTBIT_WIN_SHA="6bf1ba8137332d6abde130730b2a4acaad42a3baa5b4ac69312b79b3726519ee"

getFluent(){
   curl $FLUENTBIT -O
 #  md5sum ${FLUENTBIT}
 #  curl $FLUENTBIT_SHA
 #tar -xpf
}

if [ ! -d docker-elk ]; then
  git clone https://github.com/deviantony/docker-elk
fi
(
    cd docker-elk
    docker-compose up -d
)

if [ ! -d fluentbit]

until [ $(curl --user elastic:changeme -Is http://localhost:9200/ | head -n 1 | wc -l) -eq 1 ]
do
   sleep 5
   echo "connecting..."
done

./setup-es.sh

echo """
exposed:
    9200: Elasticsearch HTTP
    9300: Elasticsearch TCP transport
    5601: Kibana

change password:
    docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch

cleanup:
    (cd docker-elk;docker-compose down -v)
"""

exit 0
