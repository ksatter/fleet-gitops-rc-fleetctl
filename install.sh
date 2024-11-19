#! /bin/bash    

 FLEET_VERSION="$(curl "$FLEET_URL/api/v1/fleet/version" --header "Authorization: Bearer $FLEET_API_TOKEN" --fail --silent)"

BRANCH=$(echo "$FLEET_VERSION" | jq -r '.branch')
VERSION=$(echo "$FLEET_VERSION" | jq -r '.version')
REVISION=$(echo "$FLEET_VERSION" | jq -r '.revision')

echo ${FLEET_BRANCH:0:2}

if [[ -z "${FLEET_VERSION}" ]]; then 
  echo "Failed to get Fleet version from $FLEET_URL, installing latest version of fleetctl"
    #npm install -g fleetctl
elif [[ "${BRANCH:0:2}" == "rc" ]]; then 
  echo "rc version detected"
else
  echo "install version"
  # npm install -g "fleetctl@$FLEET_VERSION" || npm install -g fleetctl
fi
