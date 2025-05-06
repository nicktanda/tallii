# exit on error
set -o errexit

bundle lock --add-platform ruby

# Ensure nokogiri builds against system libraries
bundle config set force_ruby_platform true
bundle config set build.nokogiri --use-system-libraries

bundle install

bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed
