FROM odavid/jenkins-jnlp-slave:alpine

LABEL description="Inbound Jenkins Agent with Docker in Docker support and additional tools (curl, jq, mqtt clients)" \
      maintainer="jforge <github@jforge.de>"

USER root

RUN set -eux \
    && echo "Installing additional tools" \
    ; \
    apk add --no-cache \
      ip6tables \
      curl \
      jq \
      yq \
      mosquitto-clients \
      yarn \
      npm \
      uuidgen \
      python2 \
      make \
      sipcalc
