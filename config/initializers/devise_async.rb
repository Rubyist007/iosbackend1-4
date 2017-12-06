#p '!!!!!!!!!!!!!!!!!!!!!!!!!!!'
#p Devise::Async
#p Devise::Async.backend
#p '!!!!!!!!!!!!!!!!!!!!!!!!!!!'

Devise::Async.setup do |config|
  config.enabled = true
  #config.backend = :sidekiq
  #config.queue = :default
end
#Devise::Async.backend = :sidekiq
#Devise::Async.queue = :default
