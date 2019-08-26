ARG ES_VERSION
FROM docker.elastic.co/kibana/kibana:${ES_VERSION}
COPY --chown=kibana:kibana config/kibana.yml /usr/share/kibana/config/
