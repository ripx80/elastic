#!/bin/sh

openssl s_client -showcerts -servername 192.168.100.10 -connect 192.168.100.10:9200 </dev/null

exit

