# exit on error
set -o errexit

# Ensure Ruby platform for native gems
bundle lock --add-platform x86_64-linux

# Force native extensions to be built (not precompiled ones)
bundle config set force_ruby_platform true

bundle install

bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed
