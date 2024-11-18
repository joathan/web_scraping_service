# frozen_string_literal: true

require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq::Cron::Job.create(
  name: 'ScrapeTaskWorker - Runs every 1 minute',
  cron: '*/1 * * * *',
  class: 'ScrapeTaskWorker'
)