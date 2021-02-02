ARG JENKINS_INBOUND_AGENT_VERSION

FROM jenkins/inbound-agent:${JENKINS_INBOUND_AGENT_VERSION:-alpine}

LABEL description="Inbound Jenkins Agent with Docker and Docker Compose" \
      maintainer="jforge <github@jforge.de>"

USER root

# Alpine seems to come with libcurl baked in, which is prone to mismatching
# with newer versions of curl. The solution is to upgrade libcurl.
RUN apk update && apk add -u libcurl curl
# add mqtt tools
RUN apk add mosquitto-clients jq
# Install Docker client
ARG DOCKER_VERSION=20.10.2
ARG DOCKER_COMPOSE_VERSION=1.27.4
RUN curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-$DOCKER_VERSION.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker
RUN curl -fsSL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN touch /debug-flag

RUN addgroup -S docker
RUN addgroup jenkins docker

USER jenkins
