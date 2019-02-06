#!/usr/bin/env sh
set -e
set -v

docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD" --password-stdin

docker pull ${DOCKER_REPOSITORY}:last_successful_build || true
docker pull ${DOCKER_REPOSITORY}:${TRAVIS_COMMIT} || true

docker build -t ${DOCKER_REPOSITORY}:${TRAVIS_COMMIT} --pull=true .

docker push ${DOCKER_REPOSITORY}:${TRAVIS_COMMIT}

docker tag -f ${DOCKER_REPOSITORY}:${TRAVIS_COMMIT} ${DOCKER_REPOSITORY}:last_successful_build

docker push ${DOCKER_REPOSITORY}:last_successful_build

