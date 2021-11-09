#!/usr/bin/env bash
#
# Fast review for the expected tools in the image
#

IMAGE=jforge/jenkins-inbound-agent:additional-tools

function runAgentShell {
  COMMAND=$1
  docker run -it --rm --entrypoint /bin/bash $IMAGE -c "$COMMAND"
}

echo "<?> cURL:"
runAgentShell "curl --version"

echo "<?> jq:"
runAgentShell "jq --version"

echo "<?> mosquitto tools"
runAgentShell "find / -name mosquitto_* | xargs ls -al"

echo "<?> yarn:"
runAgentShell "yarn --version"

echo "<?> npm:"
runAgentShell "npm --version"

echo "<?> python:"
runAgentShell "python --version"

echo "<?> make":
runAgentShell "make -v"
