Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, '1e595466ab8a4671a4210d974b5008bf', '14eed34d8a9244338c6fb85d308e0be5'
  provider :google_oauth2, '505150086257-jmhnraghosdeaq8aum31bhhfqb2qmae0.apps.googleusercontent.com', 'TvzlFh2x3EaLfETTpnZ4Pl95', skip_jwt: true
  provider :twitter, '7AnydeAscaWXICHZ5qUkq35Vf', 'GqPPSNqCgZXQuBf962XKaaijawifMlz7X7bWDI6OWSZFax8Z9k'
  provider :facebook, '142528229808784', 'a85b8e4107bd9f083a754d08feb18fee'
end


