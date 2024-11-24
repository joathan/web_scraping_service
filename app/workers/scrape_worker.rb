# frozen_string_literal: true

class ScrapeWorker
  include Sidekiq::Worker

  def perform(task_id, token)
    task = ScrapeTask.find(task_id)

    Scraping::ProcessorService.new(task, token).process
  rescue StandardError => e
    Rails.logger.error({ message: "Worker Error", task_id: task_id, error: e.message }.to_json)

    raise e
  end
end
