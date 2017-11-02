Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, '1e595466ab8a4671a4210d974b5008bf', '14eed34d8a9244338c6fb85d308e0be5'
  provider :google_oauth2, '505150086257-jmhnraghosdeaq8aum31bhhfqb2qmae0.apps.googleusercontent.com', 'TvzlFh2x3EaLfETTpnZ4Pl95'
end


