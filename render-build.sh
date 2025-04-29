# exit on error
set -o errexit

bundle config set force_ruby_platform true
bundle lock --add-platform x86_64-linux

gem install bundler
bundle update --bundler

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

bundle exec rails db:seed