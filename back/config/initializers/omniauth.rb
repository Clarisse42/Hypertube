OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:auth_failure).call(env)
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'aea129c3b5ae23d12b2d', '4a482bd0043c7cedc44ddec8eb7e465f1ec6719e'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '104604940295745', '315fc0677641fe76d7c3d287e0f57dfe'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '519615115698-rnr478nmrh2g1ntghc0a5go35307ea7l.apps.googleusercontent.com', '3S6dKqX5X2YqpljyOKxvVdM3'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, 'dc6nuvec8xe706g03wv6zs9fz3esdq', '8e4nwxn1wdcktbd3kideebann4j6bh'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :amazon, 'amzn1.application-oa2-client.1804a6010abc40218b9ea49125d415db', '6420714c7f5c0b310d57e3e205aa118f8f6e386415de1d756095c5662305c6d2'
end