Devise::Async.setup do |config|
  config.backend = :delayed_job
  config.queue   = :devise_async
end
