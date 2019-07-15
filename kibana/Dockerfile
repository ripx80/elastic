ARG ES_VERSION
#COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /usr/share/elasticsearch/config/
# https://github.com/elastic/kibana-docker
FROM docker.elastic.co/kibana/kibana:${ES_VERSION}

# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>
