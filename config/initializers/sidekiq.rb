require 'sidekiq/cli'

if ENV['REDIS_URL'] && ENV['RAILS_ENV'] == 'production'
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Thread.abort_on_exception = true
  Thread.new do
    sidekiq = Sidekiq::CLI.instance
    sidekiq.parse(['-c', '1'])
    sidekiq.run
  end

  Rails.application.config.active_job.queue_adapter = :sidekiq
end
