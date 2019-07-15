# Elastic with Kibana

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
