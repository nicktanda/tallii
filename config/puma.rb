# config/puma.rb

# Puma serves each request in a thread from an internal thread pool.
# Keep threads low on 512MB instances.
max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS", 1))
min_threads_count = Integer(ENV.fetch("RAILS_MIN_THREADS", max_threads_count))
threads min_threads_count, max_threads_count

# Longer timeout only in development.
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Listen on the provided PORT (Render sets this).
port Integer(ENV.fetch("PORT", 3000))

# Default to production on the platform.
environment ENV.fetch("RAILS_ENV", "production")

# PID file location.
pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

# *** IMPORTANT: Single-process mode (no cluster workers). ***
# 0 workers = no master/child processes; safest for tight RAM.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 0))

# Load the app before forking (harmless in single mode; useful if you ever add workers).
preload_app!

# Re-establish DB connection when workers boot (only runs if workers > 0).
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  GC.compact if GC.respond_to?(:compact)
end

# Allow `bin/rails restart` to restart Puma.
plugin :tmp_restart
