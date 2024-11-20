# frozen_string_literal: true

module Scraping
  class CreatorService
    def self.call(params)
      scrape_task = ScrapeTask.create!(
        task_id: params[:task_id],
        url: params[:url],
        status: :pending,
        user_id: params[:user_id]
      )

      ScrapeWorker.perform_async(scrape_task.id)

      scrape_task
    rescue ActiveRecord::RecordInvalid => e
      { error: e.record.errors.full_messages }
    end
  end
end
