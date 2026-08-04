#!/usr/bin/env bash

set -euo pipefail

. /opt/conda/bin/activate

CACHE_DIR="$HOME/.cache"
mkdir -p "$CACHE_DIR"

LOGFILE="$CACHE_DIR/calkit-codespace.log"

log() {
	printf '%s\n' "$*" >> "$LOGFILE"
}

if ! git remote get-url origin >/dev/null 2>&1; then
	if [ -n "${GITHUB_REPOSITORY:-}" ]; then
		git remote add origin "https://github.com/${GITHUB_REPOSITORY}.git"
		log "Added origin remote from GITHUB_REPOSITORY=${GITHUB_REPOSITORY}"
	else
		log "No origin remote and GITHUB_REPOSITORY is unset; skipping calkit config and pull"
		exit 0
	fi
fi

if calkit config github-codespace >> "$LOGFILE" 2>&1; then
	log "Configured Calkit for GitHub Codespaces"
else
	log "calkit config github-codespace failed; see log output above"
fi

if calkit pull >> "$LOGFILE" 2>&1; then
	log "Pulled Calkit/DVC content"
else
	log "calkit pull failed; see log output above"
fi
