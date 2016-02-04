require 'sidekiq/cli'

if ENV['REDIS_URL'] && ENV['SIDEKIQ_CONCURRENCY']
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Thread.abort_on_exception = true
  Thread.new do
    sidekiq = Sidekiq::CLI.instance
    sidekiq.parse(['-c', ENV['SIDEKIQ_CONCURRENCY']])
    sidekiq.run
  end

  Rails.application.config.active_job.queue_adapter = :sidekiq
end
