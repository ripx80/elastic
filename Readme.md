# Elastic

This is only a dev repo for various scripts and tests. Nothing for prod.

## Elastic with Kibana

Start the dev environment:

```bash
ES_VERSION=7.2.0 docker-compose up
curl --user elastic:changeme  http://127.0.0.1:9200/_cat/health
```

Now set random generated passwords for all accounts

```bash
docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch
```

Change the password in kibana.yml file and restart the service:

```bash
docker-compose restart kibana
```

Login with elastic user and your new password. Change the permissions of kibana user and relogin with this user.

## Links

[based code](https://github.com/deviantony/docker-elk)
[scale up](https://github.com/deviantony/docker-elk/wiki/Elasticsearch-cluster)
[production settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-prod-cluster-composefile)
[bootstrap checks](https://www.elastic.co/guide/en/elasticsearch/reference/current/bootstrap-checks.html)

## Production

```bash
sysctl -w vm.max_map_count=262144
```

## Elastic in Dev and TLS

This setup will create a three node cluster. Default it will be in production mode. But if you will test it and try things out its recommendet to switch to dev mode.
All stdout logs will be shipped via fluent-bit to elastic.
**Before you start the es cluster start the fluent-bit prod node under fluentd**
You become some errors on the beginning from fluent-bit but they are buffed and send if elastic is up and running.

### Dev

In development mode you can inspect the cluster.
Security features are disabled for simplicity. If you need a login page or tls between instances use the production mode.

```sh
docker-compose -f docker-compose-dev.yml -e .env-dev -d
```

### Production TLS

- [tls guide](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html#get-started-docker-tls)
- [production settings](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#next-getting-started-tls-docker)

In production mode you must set the security feature and have ssl certs.
Its recommended by elastic to use the conf files in prod mode but you can overwrite it via env vars

For the initinal setup you must do the following (saved in volumes).

```sh
docker-compose -f create-certs.yml run --rm create_certs
docker-compose up -d
docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords \
auto --batch --url https://es01:9200"
# change the pw of kibana_system in docker-compose file and save the passwords
# change the elastic uer password in fluent-bit.conf
# then restart the env
docker-compose stop
docker-compose up -d
```

### Info

- healthy shards ```text http://127.0.0.1:9200/_cluster/health/?level=shards```
- rollover: ```text https://www.elastic.co/guide/en/elasticsearch/reference/7.9//``` ```text getting-started-index-lifecycle-management.html#ilm-gs-alias-apply-policy```

[doc](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-prod-cluster-composefile)

[calc](https://gbaptista.github.io/elastic-calculator/)

## node exporter

```bash
docker run -d \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter \
  --path.rootfs=/host

# 2. check if running
GET /_ilm/status

# 3. check for condition
POST test-idx/_rollover?dry_run
{  "conditions": {
    "max_age":   "7d",
    "max_docs":  5
  }
}

GET test-idx/_ilm/explain
```

## 3.1. Increase checks for testing

default every 10min check the cluster for conditions

```text
GET /_cluster/settings
PUT /_cluster/settings
{
  "persistent": {
    "indices.lifecycle.poll_interval": "1m"
  }
}
```

## 3.2. Compress old indexes

POST inactive-logs-1/_forcemerge?max_num_segments=1

### 4. set max docs to 5 and push logs

```text
POST test-service/_bulk
{ "create": {}}
{ "text": "Some log message", "@timestamp": "2016-07-01T01:00:00Z" }
{ "create": {}}
{ "text": "Some log message", "@timestamp": "2016-07-02T01:00:00Z" }
{ "create": {}}
{ "text": "Some log message", "@timestamp": "2016-07-03T01:00:00Z" }
{ "create": {}}
{ "text": "Some log message", "@timestamp": "2016-07-04T01:00:00Z" }
{ "create": {}}
{ "text": "Some log message", "@timestamp": "2016-07-05T01:00:00Z" }
{ "create": {}}
{ "text": "Some log message", "@timestamp": "2016-07-05T01:00:00Z" }
```

## Troubleshooting

### Grafana can not connect to es

if you have enable the prod env with tls enabled then you must add the cacert to the grafana and enable the with CA Cert option.
configure the elastic user and the right password. Look into the grafana container logs if something went wrong.
Check if the certificate is assigned to the host or the ip address you are using

## old

Start the dev environment:

```bash
ES_VERSION=7.2.0 docker-compose up
curl --user elastic:changeme  http://127.0.0.1:9200/_cat/health
```

Now set random generated passwords for all accounts

```bash
docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch
```

Change the password in kibana.yml file and restart the service:

```bash
docker-compose restart kibana
```

Login with elastic user and your new password. Change the permissions of kibana user and relogin with this user.
