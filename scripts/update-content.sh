#!/usr/bin/env bash

while ! docker info > /dev/null 2>&1; do sleep 1; done && conda init bash && . /opt/conda/bin/activate && calkit check envs
