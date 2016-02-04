require 'sidekiq/cli'

if ENV['REDIS_URL'] && Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'] }
  end

  if concurrency = ENV['SIDEKIQ_CONCURRENCY']
    Thread.abort_on_exception = true
    Thread.new do
      sidekiq = Sidekiq::CLI.instance
      sidekiq.parse(['-c', concurrency])
      sidekiq.run
    end
  end

  Rails.application.config.active_job.queue_adapter = :sidekiq
end
