# frozen_string_literal: true

module Scraping
  class ProcessorService
    def initialize(task)
      @task = task
    end

    def process
      result = Scraping::ExecutorService.new(@task).perform

      if result[:status] == :success
        @task.update!(status: :completed, results: result[:data])
        Scraping::NotifierService.new(@task).notify
      else
        @task.update!(status: :failed)
      end
    rescue StandardError => e
      @task.update!(status: :failed, error_message: e.message)
      Rails.logger.error({ message: "Task Processing Error", task_id: @task.id, error: e.message }.to_json)
      raise e
    end
  end
end