#! /usr/bin/env bash

#FLEET_VERSION="$(curl "$FLEET_URL/api/v1/fleet/version" --header "Authorization: Bearer $FLEET_API_TOKEN" --fail --silent)"

FLEET_VERSION="$(curl "https://nveval.cloud.fleetdm.com/version" --fail --silent)"

VERSION=$(echo "$FLEET_VERSION" | jq -r '.version' || echo "")
echo $VERSION

if [[ (-z "${VERSION}" ) ]]; then 
  echo "Failed to get Fleet version from $FLEET_URL, installing latest version of fleetctl"
  npm install -g fleetctl
else

  BRANCH=$(echo "$FLEET_VERSION" | jq -r '.branch')
  REVISION=$(echo "$FLEET_VERSION" | jq -r '.revision')

  if [[ "${BRANCH:0:2}" == "rc" ]]; then 

    git clone https://github.com/fleetdm/fleet.git --single-branch $BRANCH
    cd $BRANCH
    git reset --hard $REVISION
    make deps
    make fleetctl

    ls -a ./build

  else

    echo "install version"
    # npm install -g "fleetctl@$FLEET_VERSION" || npm install -g fleetctl

  fi
fi

