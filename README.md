# Jenkins Inbound Agent with enhanced capabilities

This docker image is originally based on jenkins/inbound-agent and was
replaced with the alpine image of [odavid/jenkins-jnlp-slave](https://hub.docker.com/r/odavid/jenkins-jnlp-slave)
in order to resolve the docker-in-docker requirement for more flexible CI agent 
deployments required to support docker and docker-compose calls in the qa environment.

To be able to use MQTT and to ease handling of json objects the mosquitto_clients
and jq library are added.

## Build

To build the image manually:

```
docker build --no-cache -t jforge/jenkins-inbound-agent .
```

## Usage

Use the jenkins-inbound-agent command line options or use corresponding environment variables.

The privileged mode (`--privileged`) is required and either the `-e DIND=true` flag
or the docker daemon socket mount (`-v /var/run/docker.sock:/var/run/docker.sock`).

For ease of use of docker inside jenkins build pipelines use the docker-in-docker feature
by setting the flag DIND=true as an environment variable.

Refer to the jenkins master configuration for this agent node for the node label
and ensure that configuration uses `/home/jenkins/agent` as the remote root folder.

### Docker run

```
docker run --init --privileged \
  -e JENKINS_URL=https://jenkins.example.org \
  -e JENKINS_WEB_SOCKET=true \
  -e JENKINS_SECRET=TheAgentSecret  \
  -e JENKINS_AGENT_NAME=MyInboundAgent \
  -e DIND=true \
  -e TINI_SUBREAPER=true \
  jforge/jenkins-inbound-agent:latest
```

### Docker-compose

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
      - TINI_SUBREAPER=true
```

### Using the image with a Jenkins Pipeline

To use the image with the added feature prepare the Jenkins node on the master
and start the node as described above.

### Zombie Reaping (removing orphaned processes)

In case of orphaned process the [tini program](https://github.com/krallin/tini)
is responsible for removing them and performing signal forwarding. 
It runs transparently as a single child process (on a container).

Orphan processes consume resources, affect the process identifier namespace they 
run in and make the environment unstable or unusable, so that they should be removed.

By default, Tini needs to run using the process identifier (PID) 1 to remove 
orphaned processes. If PID 1 cannot be used or if containers are run without 
PID namespace isolation, the Tini program should be registered as a process 
subreaper by setting the `TINI_SUBREAPER` environment variable to `true`.
This ensures the orphaned processes to be re-parented as children of the 
Tini program which can then remove them to complete its execution.

## Additional tools

To test further tools added to the Dockerfile apk call, use another entrypoint
and say `apk add <package_name>` to verify the integration into a new image:

```
docker run -it --rm --entrypoint /bin/bash jforge/jenkins-inbound-agent:additional-tools  
```

Verify the availability of the tools with `./test/review-tools.sh`.


## References

- [Github Jenkins Inbound Agent Project](https://github.com/jenkinsci/docker-inbound-agent)
