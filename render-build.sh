set -o errexit

# Ensure correct Ruby platform is locked
bundle lock --add-platform ruby

# Unset any previous force_ruby_platform
bundle config unset force_ruby_platform

# Force Nokogiri to build from source
bundle config set force_ruby_platform true

# Install gems, forcing native build
bundle install

# Build JS/CSS assets
bundle exec rake tailwindcss:install
bundle exec rake tailwindcss:build
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Setup DB
bundle exec rails db:migrate
bundle exec rails db:seed
