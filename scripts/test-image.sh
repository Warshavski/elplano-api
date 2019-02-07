#!/usr/bin/env sh
set -e
set -v

COMPOSE_FILE=docker-compose.test.yml

docker-compose -f $COMPOSE_FILE build --pull
docker-compose -f $COMPOSE_FILE up -d && docker ps
docker-compose -f $COMPOSE_FILE exec app bin/rake db:create db:migrate
docker-compose -f $COMPOSE_FILE exec app bin/bundle exec rspec
