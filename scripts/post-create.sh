#!/usr/bin/env bash

TEMP_ENV=.calkit/temp/.env

set -euo pipefail

mkdir -p "$(dirname "$TEMP_ENV")"

if [ -f "$TEMP_ENV" ]; then
	# Reuse any values staged by initializeCommand or a previous container run.
	# If the file is empty or invalid, fall back to the container's calkit config.
	if grep -q '^CALKIT_TOKEN=' "$TEMP_ENV" 2>/dev/null || grep -q '^CALKIT_DVC_TOKEN=' "$TEMP_ENV" 2>/dev/null; then
		# shellcheck disable=SC1090
		source "$TEMP_ENV"
	fi
fi

if [ -z "${CALKIT_TOKEN:-}" ]; then
	CALKIT_TOKEN=$(calkit config get token 2>/dev/null || true)
fi

if [ -z "${CALKIT_DVC_TOKEN:-}" ]; then
	CALKIT_DVC_TOKEN=$(calkit config get dvc_token 2>/dev/null || true)
fi

if [ -n "${CALKIT_TOKEN:-}" ]; then
	calkit config set token "$CALKIT_TOKEN"
fi

if [ -n "${CALKIT_DVC_TOKEN:-}" ]; then
	calkit config set dvc_token "$CALKIT_DVC_TOKEN"
fi

rm -f "$TEMP_ENV"
