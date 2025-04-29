# exit on error
set -o errexit

# STEP 1: Add Linux platform to Gemfile.lock
bundle lock --add-platform x86_64-linux

# STEP 2: Force source builds of native extensions (Nokogiri, etc.)
bundle config set force_ruby_platform true

# STEP 3: Install gems
bundle install

# STEP 4: Manually install tailwindcss executable for Linux
bin/rails tailwindcss:install

# STEP 5: Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# STEP 6: Run DB tasks
bundle exec rails db:migrate
bundle exec rails db:seed
