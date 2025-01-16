# exit on error
set -o errexit

bundle config unset force_ruby_platform
bundle config set --local force_ruby_platform false
gem install nokogiri --platform=ruby
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

bundle exec rails db:seed