# frozen_string_literal: true

require 'bunny'

class NotificationPublisher
  QUEUE_NAME = 'notifications.scrapes.completed'

  def initialize
    @connection = nil
    @channel = nil
    @queue = nil
  end

  def publish(message)
    validate_message!(message)
    queue.publish(message.to_json, persistent: true)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def connection
    @connection ||= Bunny.new(
      host: ENV.fetch('RABBITMQ_HOST', 'localhost'),
      port: ENV.fetch('RABBITMQ_PORT', 5672).to_i,
      user: ENV.fetch('RABBITMQ_DEFAULT_USER', 'guest'),
      password: ENV.fetch('RABBITMQ_DEFAULT_PASS', 'guest')
    ).start
  end

  def channel
    @channel ||= connection.create_channel
  end

  def queue
    @queue ||= channel.queue(
      QUEUE_NAME,
      durable: true,
      exclusive: false,
      auto_delete: false
    )
  end

  def validate_message!(message)
    raise ArgumentError, 'Message must be a Hash' unless message.is_a?(Hash)
  end

  def handle_error(exception)
    # Log the error or send to an error tracking service
    Rails.logger.error("Failed to publish message: #{exception.message}")
    raise exception
  end

  def close_connection
    @channel&.close
    @connection&.close
  rescue StandardError => e
    Rails.logger.warn("Failed to close RabbitMQ connection: #{e.message}")
  end
end
