# Use your cache store for counters (Redis recommended in production)
Rack::Attack.cache.store = Rails.cache

# -------------------------
# Your existing throttles
# -------------------------

Rack::Attack.throttle("requests by ip", limit: 5, period: 2) do |request|
  request.ip
end

# Throttle login attempts for a given email parameter to 6 reqs/minute
Rack::Attack.throttle('limit logins per email', limit: 6, period: 60) do |req|
  if (req.path == '/login' || req.path == '/mobile_app/login') && req.post?
    req.params['email'].to_s.downcase.gsub(/\s+/, "")
  end
end

# Example dynamic throttle by REMOTE_USER
limit_proc  = proc { |req| req.env["REMOTE_USER"] == "admin" ? 100 : 1 }
period_proc = proc { |req| req.env["REMOTE_USER"] == "admin" ? 1 : 60 }

Rack::Attack.throttle('request per ip', limit: limit_proc, period: period_proc) do |request|
  request.ip
end

# -------------------------
# NEW: Block WordPress scanners
# -------------------------
# Match common WP probe signatures anywhere in the path (case-insensitive).
Rack::Attack.blocklist('block wp probes') do |req|
  path = req.path.to_s.downcase
  path.include?('wlwmanifest.xml') ||
    path.include?('wp-admin')      ||
    path.include?('wp-login.php')  ||
    path.include?('xmlrpc.php')    ||
    path.include?('wp-content')    ||
    path.include?('wp-includes')
end

# Return 410 Gone for blocklisted requests (faster than 404 for scanners)
Rack::Attack.blocklisted_response = ->(_env) {
  [410, {'Content-Type' => 'text/plain'}, ["Gone\n"]]
}

# (Optional) Custom 429 for throttles
Rack::Attack.throttled_response = ->(_env) {
  [429, {'Content-Type' => 'text/plain'}, ["Retry later\n"]]
}

# (Optional) Safelist health checks if you have one
# Rack::Attack.safelist('healthcheck') { |req| req.path == '/up' }

# config/initializers/rack_attack.rb

Rack::Attack.blocklist('block cms probes') do |req|
  path_q = "#{req.path}?#{req.query_string}".downcase

  wp =
    path_q.include?('wlwmanifest.xml') ||
    path_q.include?('wp-admin') ||
    path_q.include?('wp-login.php') ||
    path_q.include?('xmlrpc.php') ||
    path_q.include?('wp-content') ||
    path_q.include?('wp-includes')

  joomla =
    path_q.include?('media/system/') ||   # e.g. /media/system/js/core.js
    path_q.include?('administrator') ||
    path_q.include?('components/com_') ||
    path_q.include?('templates/') ||
    path_q.include?('modules/') ||
    path_q.include?('plugins/system') ||
    path_q.include?('index.php?option=com_')

  wp || joomla
end

Rack::Attack.blocklisted_response = ->(_) { [410, {'Content-Type' => 'text/plain'}, ["Gone\n"]] }
