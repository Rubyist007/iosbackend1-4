Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, '2a15a470a8974ca6ae0edc2eb1e4c1e4', '1bd286ba923b4f599588fc89be2cd59b'
end
