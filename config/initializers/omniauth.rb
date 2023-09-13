# config/initializers/omniauth.rb
OmniAuth.config.logger = Rails.logger
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2,
#            ENV['GOOGLE_CLIENT_ID'],
#            ENV['GOOGLE_SECRET'],
#            scope: "email",
#            skip_jwt: true,
#            provider_ignores_state: Rails.env.development?
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'], {
    scope: 'userinfo.email, userinfo.profile, plus.me',
    include_granted_scopes: true,
    callback_path: '/auth/google_oauth2/callback',
    provider_ignores_state: Rails.env.development?
  }
end

OmniAuth.config.allowed_request_methods = %i(get)
# OmniAuth.config.silence_get_warning = true

