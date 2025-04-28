#!/usr/bin/env bash

# exit on error
set -o errexit

# Ensure we use system libraries for Nokogiri
export NOKOGIRI_USE_SYSTEM_LIBRARIES=true

# Remove cached bundles
rm -rf vendor/bundle
rm -rf .bundle
rm -rf tmp/cache

# Remove old Gemfile.lock (optional but safer)
rm -f Gemfile.lock

# Force fresh install
bundle config unset force_ruby_platform
bundle config set --local force_ruby_platform false
bundle install --jobs 4 --retry 3 --clean

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run database migrations and seeds
bundle exec rails db:migrate
bundle exec rails db:seed
