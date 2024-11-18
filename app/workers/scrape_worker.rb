# frozen_string_literal: true

class ScrapeWorker
  include Sidekiq::Worker

  def perform(task_id)
    task = ScrapeTask.find(task_id)

    result = ScrapingService.new(task).perform

    if result[:status] == :success
      task.update!(status: :completed, results: result[:data])
      NotificationService.new(task).notify
    else
      task.update!(status: :failed)
    end
  rescue StandardError => e
    task.update!(status: :failed) if task.persisted?
    Rails.logger.error({ message: "Worker Error", task_id: task_id, error: e.message }.to_json)
    raise e
  end
end
