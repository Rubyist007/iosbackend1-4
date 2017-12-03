api_keys = Rails.application.secrets

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, api_keys[:google_oAuth][:api_key], api_keys[:google_oAuth][:api_secret], skip_jwt: true
  provider :instagram, api_keys[:instagram_oAuth][:api_key], api_keys[:instagram_oAuth][:api_secret] 
  provider :twitter, api_keys[:twitter_oAuth][:api_key], api_keys[:google_oAuth][:api_secret]
  provider :facebook, api_keys[:facebook_oAuth][:api_key], api_keys[:facebook_oAuth][:api_secret]
end
