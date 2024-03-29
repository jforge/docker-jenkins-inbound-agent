FROM odavid/jenkins-jnlp-slave:alpine

LABEL description="Inbound Jenkins Agent with Docker in Docker support and additional tools (curl, jq, mqtt clients)" \
      maintainer="jforge <github@jforge.de>"

USER root

RUN set -eux \
    && echo "Installing additional tools" \
    ; \
    apk add --no-cache \
		  curl \
		  mosquitto-clients \
      yarn \
		  jq
