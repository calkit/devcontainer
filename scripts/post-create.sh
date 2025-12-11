#!/usr/bin/env bash

TEMP_ENV=.calkit/temp/.env
source $TEMP_ENV && calkit config set token $CALKIT_TOKEN && calkit config set dvc_token $CALKIT_DVC_TOKEN
rm -f $TEMP_ENV
