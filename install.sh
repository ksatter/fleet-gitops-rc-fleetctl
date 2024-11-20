#! /usr/bin/env bash

FLEET_VERSION="$(curl "$FLEET_URL/api/v1/fleet/version" --header "Authorization: Bearer $FLEET_API_TOKEN" --fail --silent)"

VERSION=$(echo "$FLEET_VERSION" | jq -r '.version' 2>/dev/null || echo "")
BRANCH=$(echo "$FLEET_VERSION" | jq -r '.branch' 2>/dev/null)
REVISION=$(echo "$FLEET_VERSION" | jq -r '.revision' 2>/dev/null)

echo $VERSION

if [[ (-z "${VERSION}" ) ]]; then 
  echo "Failed to get Fleet version from $FLEET_URL, installing latest version of fleetctl"
  npm install -g fleetctl
elif [[ "${BRANCH:0:2}" == "rc" ]]; then 
  echo "Fleet is currently running a release candidate, building matching fleetctl version"
  git clone --branch $BRANCH https://github.com/fleetdm/fleet.git 
  cd fleet
  git reset --hard $REVISION
  make fleetctl
  sudo mv ./build/fleetctl /usr/bin
else
  echo "Installing mathing fleetctl version"
  npm install -g "fleetctl@$FLEET_VERSION" || npm install -g fleetctl
fi

echo "Installed fleetctl version: \n\n\t\t $(fleetctl --version)"