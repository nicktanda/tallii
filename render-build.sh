set -o errexit

# Configure bundler to install platform-specific dependencies
bundle config set force_ruby_platform true
bundle lock --add-platform x86_64-linux

bundle install

# ⬇️ Download the Tailwind binary manually to a known path
mkdir -p bin
curl -L https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64 -o bin/tailwindcss
chmod +x bin/tailwindcss

# 🔄 Tell tailwindcss-rails to use this binary
export TAILWINDCSS_BINARY="./bin/tailwindcss"

# Precompile assets
bundle install
bundle exec rails assets:precompile
bundle exec rails db:migrate
bundle exec rails db:seed
