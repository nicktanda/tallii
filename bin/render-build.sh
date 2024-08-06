#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

bin/rails db:environment:set RAILS_ENV=production
DISABLE_DATABASE_ENVIRONMENT_CHECK=1
bin/rails db:drop
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

yarn install

bin/rails server