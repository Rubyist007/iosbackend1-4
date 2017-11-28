api_keys = YAML::load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, api_keys['google_oAuth']['api_key'], api_keys['google_oAuth']['api_secret']
  provider :google_oauth2, api_keys['google_oAuth']['api_key'], api_keys['google_oAuth']['api_secret'], skip_jwt: true
  provider :twitter, api_keys['google_oAuth']['api_key'], api_keys['google_oAuth']['api_secret']
  provider :facebook, api_keys['facebook_oAuth']['api_key'], api_keys['facebook_oAuth']['api_secret']
end


