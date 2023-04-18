#!/usr/bin/env bash

PYTHON_VERSION=python3.8
VIRTUALENV_NAME=python
PYTHON_LAYER_FILENAME=layer.zip

python -m virtualenv ${VIRTUALENV_NAME} -p ${PYTHON_VERSION}
./${VIRTUALENV_NAME}/bin/pip install -r requirements.txt
zip -D -r ${PYTHON_LAYER_FILENAME} ${VIRTUALENV_NAME}/lib/${PYTHON_VERSION}/site-packages/
rm -rf ${VIRTUALENV_NAME}
