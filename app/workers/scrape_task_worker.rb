# frozen_string_literal: true

class ScrapeTaskWorker
  include Sidekiq::Worker

  def perform
    ScrapeTask.where(status: [:pending, :failed]).find_each(batch_size: 100) do |task|
      Task::ProcessorService.new(task).process
    end
  end
end
