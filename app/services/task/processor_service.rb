# frozen_string_literal: true

module Task
  class ProcessorService
    def initialize(task)
      @task = task
    end

    def process
      result = ScrapingService.new(@task).perform

      if result[:status] == :success
        ActiveRecord::Base.transaction do
          @task.update!(status: :completed, results: result[:data], error_message: nil)

          NotificationService.new(@task).notify
        end
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
