#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

bin/rails db:environment:set RAILS_ENV=production
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

yarn install

bin/rails server