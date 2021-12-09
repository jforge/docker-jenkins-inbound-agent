#!/usr/bin/env bash
#
# Fast review for the expected tools in the image
#
IMAGE=jforge/jenkins-inbound-agent:additional-tools

function runAgentShell {
  COMMAND=$1
  docker run -it --rm --entrypoint /bin/bash $IMAGE -c "$COMMAND"
}

TOOL_VERSION=`cat <<EOM
[
  { "ip6tables": "ip6tables --version" },
  { "curl": "curl --version" },
  { "jq": "jq --version" },
  { "yq": "yq --version" },
  { "mosquitto tools": "find / -name mosquitto_* | xargs ls -al" },
  { "yarn": "yarn --version" },
  { "npm": "npm --version" },
  { "uuidgen": "uuidgen --version" },
  { "python": "python --version" },
  { "make": "make -v" },
  { "sipcalc": "sipcalc --version" }
]
EOM
`

for row in $(echo $TOOL_VERSION | jq -r '.[] | @base64'); do
  _jq() {
   echo ${row} | base64 --decode | jq -r ${1}
  }
  echo $(_jq 'keys')
  CMD=`echo $(_jq '.[]')`
  runAgentShell "$CMD"
done
