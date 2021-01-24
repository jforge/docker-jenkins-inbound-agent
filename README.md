# Jenkins Inbound Agent with enhanced capabilities

The base image jenkins/inbound-agent is enhanced with a docker client and with 
docker-compose to get an image useful for jenkins builds with respective requirements.

Be aware that Docker in Docker is insecure and can compromise your host, 
if you run untrusted Jenkins jobs.

## Build

To build the image manually:

```
docker build --no-cache -t jforge/jenkins-inbound-agent .
```

# Usage

Use the jenkins-inbound-agent command line options or use the corresponding 
environment variables.

The privileged mode (`--privileged`) and the docker daemon socket mount
(`-v /var/run/docker.sock:/var/run/docker.sock`) are required when using
docker inside a jenkins build.

Refer to the jenkins master configuration for this agent node for the node label
and ensure that configuration uses `/home/jenkins/agent` as the remote root folder.

## Docker run

```
docker run -u 1000:1000 --init --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e JENKINS_URL=https://jenkins.example.org \
  -e JENKINS_WEB_SOCKET=true \
  -e JENKINS_SECRET=TheAgentSecret  \
  -e JENKINS_AGENT_NAME=MyInboundAgent \
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
    image: jenkins/inbound-agent
    init: true
    environment:
      - JENKINS_URL=${JENKINS_MASTER_URL}
      - JENKINS_SECRET=${JENKINS_AGENT_SECRET}
      - JENKINS_AGENT_NAME=${JENKINS_AGENT_NAME}
      - JENKINS_WEB_SOCKET=true
```

Using
# References

- [Github Jenkins Inbound Agent Project](https://github.com/jenkinsci/docker-inbound-agent)
