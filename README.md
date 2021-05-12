# Jenkins Inbound Agent with enhanced capabilities

This docker images is originally based on jenkins/inbound-agent and was
replaced with the image odavid/jenkins-jnlp-slave:alpine in order to resolve
the docker-in-docker requirement for more flexible CI agent deployments, that
are required to support docker and docker-compose calls in the qa environment.

To be able to use MQTT and to ease handling of json objects the mosquitto_clients
and jq library are added.

## Build

To build the image manually:

```
docker build --no-cache -t jforge/jenkins-inbound-agent .
```

# Usage

Use the jenkins-inbound-agent command line options or use corresponding environment variables.

The privileged mode (`--privileged`) is required and either the `-e DIND=true` flag
or the docker daemon socket mount (`-v /var/run/docker.sock:/var/run/docker.sock`).

For ease of use of docker inside jenkins build pipelines use the docker-in-docker feature
by setting the flag DIND=true as an environment variable.

Refer to the jenkins master configuration for this agent node for the node label
and ensure that configuration uses `/home/jenkins/agent` as the remote root folder.

## Docker run

```
docker run --init --privileged \
  -e JENKINS_URL=https://jenkins.example.org \
  -e JENKINS_WEB_SOCKET=true \
  -e JENKINS_SECRET=TheAgentSecret  \
  -e JENKINS_AGENT_NAME=MyInboundAgent \
  -e DIND=true \
  jforge/jenkins-inbound-agent:latest
```

## Docker-compose

See the `compose` folder for a ready to use compose file.
Just create an .env file for it (or environment variables on the shell) 
specifying the 3 required environment variables.

The say `docker-compose up -d` on the target host acting as a build node.

This composition uses the webSockets connection only (instead of JNLP-4):

```
version: '3.7'
services:
  inbound-agent:
    image: jforge/jenkins-inbound-agent
    init: true
    privileged: true
    environment:
      - JENKINS_URL=${JENKINS_MASTER_URL}
      - JENKINS_SECRET=${JENKINS_AGENT_SECRET}
      - JENKINS_AGENT_NAME=${JENKINS_AGENT_NAME}
      - JENKINS_WEB_SOCKET=true
      - DIND=true
```

## Using the image with a Jenkins Pipeline

To use the image with the added feature prepare the Jenkins node on the master
and start the node as described above.

## References

- [Github Jenkins Inbound Agent Project](https://github.com/jenkinsci/docker-inbound-agent)
