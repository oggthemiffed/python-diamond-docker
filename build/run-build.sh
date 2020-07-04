#!/bin/bash

if [ "$TRAVIS_PULL_REQUEST" != "false" ] || [ "$TRAVIS_BRANCH" != "master" ]; then
  echo "Starting Branch / PR Build"
  docker buildx build \
    --progress plain \
    --platform=linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6 \
    .
  exit $?
else
  echo "Starting Master Build"
  echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin 
  TAG="${TRAVIS_TAG:-latest}"
  VERSION_TAG="${IMAGE_VERSION}.${TRAVIS_BUILD_ID}"
  docker buildx build \
      --progress plain \
      --platform=linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x \
      -t $DOCKER_REPO:$TAG \
      -t $DOCKER_REPO:$VERSION_TAG
      --push \
      .
  exit $?
fi