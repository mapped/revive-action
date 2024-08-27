#!/bin/bash

set -e
set -o pipefail

REVIVE_VERSION="v1.3.9"

if ! command -v revive &> /dev/null; then
  echo "Revive not found. Installing revive..."
  go install github.com/mgechev/revive@$REVIVE_VERSION
  echo "Revive installed"
fi

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

eval "revive $CONFIG $EXCLUDES -formatter ndjson $LINT_PATH | $REVIVE_ACTION"
