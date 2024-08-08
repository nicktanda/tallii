# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bunde exec rails assets:clean
bundle exec rails db:migrate

bundle exec rails db:seed