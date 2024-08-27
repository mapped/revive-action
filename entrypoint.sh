#!/bin/bash

set -e
set -o pipefail

REVIVE_VERSION="v1.3.9"

echo "Downloading revive $REVIVE_VERSION binary..."

# Download and untar revive action from GitHub

ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
  REVIVE_ARCH="arm64"
else
  REVIVE_ARCH="amd64"
fi

mkdir -p revive
cd revive

curl -sSL -o revive.tar.gz https://github.com/mgechev/revive/releases/download/$REVIVE_VERSION/revive_linux_$REVIVE_ARCH.tar.gz
tar -xvzf revive.tar.gz

REVIVE="$GITHUB_ACTION_PATH/revive/revive"
echo "Downloaded revive binary to $REVIVE_ACTION"

cd "$GITHUB_WORKSPACE"

REVIVE_ACTION="go run $GITHUB_ACTION_PATH/main.go"

LINT_PATH="./..."

if [ ! -z "${INPUT_PATH}" ]; then LINT_PATH=$INPUT_PATH; fi

IFS=';' read -ra ADDR <<< "$INPUT_EXCLUDE"
for i in "${ADDR[@]}"; do
  EXCLUDES="$EXCLUDES -exclude="$i""
done

if [ ! -z "${INPUT_CONFIG}" ]; then CONFIG="-config=$INPUT_CONFIG"; fi

echo "Running revive..."

eval "$REVIVE_ACTION $CONFIG $EXCLUDES -formatter ndjson $LINT_PATH | $REVIVE_ACTION"
