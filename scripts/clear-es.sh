#!/bin/bash
set -e
set -o pipefail

HOST=localhost

delete(){
    curl --user elastic:changeme -X DELETE "$HOST:9200/$1"
}
delete '_ilm/policy/test-policy'
delete '_ilm/policy/test-policy'
delete '_template/test-service'
delete '_template/test-system'
delete 'test-service-000001'
delete 'test-system-000001'


echo
exit 0