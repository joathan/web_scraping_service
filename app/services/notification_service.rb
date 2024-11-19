# frozen_string_literal: true

class NotificationService
  def initialize(task)
    @task = task
  end

  def notify
    publisher = Notification::PublisherService.new
    publisher.publish(notification_payload)
    Rails.logger.info({ message: "Notification Sent", task_id: @task.id }.to_json)
  rescue StandardError => e
    Rails.logger.error({ message: "Notification Error", task_id: @task.id, error: e.message }.to_json)
    raise e
  end

  private

  def notification_payload
    {
      scrape_task_id: @task.id,
      url: @task.url,
      results: @task.results
    }
  end
end
