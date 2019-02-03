#! /bin/sh

./scripts/services-check.sh
./scripts/prepare-db.sh
bundle exec puma -C config/puma.rb
