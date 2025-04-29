# exit on error
set -o errexit

# Ensure platform is added BEFORE install
bundle lock --add-platform x86_64-linux

# Avoid setting force_ruby_platform before installing native extensions
bundle install

# Precompile assets and setup DB
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed
