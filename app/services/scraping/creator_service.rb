# frozen_string_literal: true

module Scraping
  class CreatorService
    def self.call(url)
      scrape_task = ScrapeTask.create!(url: url, status: :pending)
      ScrapeWorker.perform_async(scrape_task.id)
      scrape_task
    rescue ActiveRecord::RecordInvalid => e
      { error: e.record.errors.full_messages }
    end
  end
end
