# Zeek with ES

setup:

```shell
$ docker run -d --name elasticsearch \
                -p 9200:9200 \
                -e discovery.type=single-node \
                blacktop/elasticsearch:x-pack-7.4.0
$ docker run -d --name kibana \
                -p 5601:5601 \
                --link elasticsearch \
                -e xpack.reporting.enabled=false \
                blacktop/kibana:x-pack-7.4.0
$ docker run --init --rm -it -v `pwd`:/pcap \
                             --link kibana \
                             --link elasticsearch \
                             blacktop/filebeat:7.4.0 -e
$ docker run -it --rm -v `pwd`:/pcap blacktop/zeek:elastic -r your.pcap local

# assuming you are using Docker For Mac.
$ open http://localhost:5601/app/kibana


## with compose

$ git clone --depth 1 https://github.com/blacktop/docker-zeek.git
$ cd docker-zeek
$ docker-compose -f docker-compose.elastic.yml up -d kibana
# wait a few minutes for "kibana" to start
$ docker-compose -f docker-compose.elastic.yml up -d filebeat
$ docker-compose -f docker-compose.elastic.yml up zeek
# wait a little while for filebeat to consume all the logs
$ open http://localhost:5601/app/kibana



# live traffic

$ docker run -d --name elasticsearch \
                -p 9200:9200 \
                -e discovery.type=single-node \
                blacktop/elasticsearch:x-pack-7.4.0
$ docker run -d --name kibana \
                -p 5601:5601 \
                --link elasticsearch \
                -e xpack.reporting.enabled=false \
                blacktop/kibana:x-pack-7.4.0
# wait a few minutes for "kibana" to start
$ docker run --init --rm -it -v `pwd`:/pcap \
                             --link kibana \
                             --link elasticsearch \
                             blacktop/filebeat:7.4.0 -e
# change eth0 to your desired interface
$ docker run --rm --cap-add=NET_RAW --net=host -v `pwd`:/pcap:rw blacktop/zeek:elastic -i af_packet::eth0 local
#Open http://localhost:5601
```

## Only zeek

```sh
#!/bin/bash

set -e
set -o pipefail

docker run --rm -v `pwd`:/pcap -v `pwd`/local.zeek:/usr/local/zeek/share/zeek/site/local.zeek blacktop/zeek -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"

exit 0

```
