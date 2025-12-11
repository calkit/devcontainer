#!/usr/bin/env bash

. /opt/conda/bin/activate; mkdir -p $HOME/.cache; calkit config github-codespace > $HOME/.cache/calkit-config.log 2>&1 || true; calkit pull > $HOME/.cache/calkit-pull.log 2>&1 || true
