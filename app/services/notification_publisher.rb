# frozen_string_literal: true

require 'bunny'

class NotificationPublisher
  def initialize
    @connection = Bunny.new(
      host: ENV['RABBITMQ_HOST'] || 'localhost',
      port: ENV['RABBITMQ_PORT'] || 5672,
      user: ENV['RABBITMQ_DEFAULT_USER'] || 'guest',
      password: ENV['RABBITMQ_DEFAULT_PASS'] || 'guest'
    ).start
    @channel = @connection.create_channel
    @queue = @channel.queue(
      'notifications.scrapes.completed',
      durable: true,
      exclusive: false,
      auto_delete: false
    )
    ensure_queue_exists
  end

  def publish(message)
    @queue.publish(message.to_json, persistent: true)
  end

  def ensure_queue_exists
    @queue.status
  rescue Bunny::NotFound
    raise 'Queue does not exist!'
  end
end
