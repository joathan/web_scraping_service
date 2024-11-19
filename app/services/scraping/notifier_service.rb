# frozen_string_literal: true

module Scraping
  class NotifierService
    def initialize(task)
      @task = task
    end

    def notify
      Notification::PublisherService.new.publish(
        scrape_task_id: @task.id,
        url: @task.url,
        results: @task.results
      )
    end
  end
end
