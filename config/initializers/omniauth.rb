Rails.application.config.middleware.use OmniAuth::Builder do
  redirect_uri = if Rails.env.production?
                   'https://yourdomain.com/auth/google_oauth2/callback'
                 else
                   'http://localhost:3001/auth/google_oauth2/callback'
                 end

  provider :google_oauth2,
           Rails.application.credentials.dig(:google, :client_id),
           Rails.application.credentials.dig(:google, :client_secret),
           {
             scope: 'email,profile',
             prompt: 'select_account',
             image_aspect_ratio: 'square',
             image_size: 200,
             redirect_uri: redirect_uri
           }
end

OmniAuth.config.allowed_request_methods = [:post, :get]
