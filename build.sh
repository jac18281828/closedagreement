#!/usr/bin/env bash

VERSION=$(git rev-parse HEAD | cut -c 1-10)

if [ -z "$VERSION" ]
then
    VERSION=$RANDOM
fi

PROJECT=jac18281828/$(basename ${PWD})

docker build . -t ${PROJECT}:${VERSION} && \
    docker rmi ${PROJECT}:${VERSION}
