# frozen_string_literal: true

module Scraping
  class ProcessorService
    def initialize(task, token)
      @task = task
      @token = token
    end

    def process
      result = Scraping::ExecutorService.new(@task).perform

      if result[:status] == :success
        @task.update!(status: :completed, results: result[:data])

        NotificationService.send_notification(task_payload_notification, @token)
      else
        @task.update!(status: :failed)
      end
    rescue StandardError => e
      @task.update!(status: :failed, error_message: e.message)
      Rails.logger.error({ message: "Task Processing Error", task_id: @task.id, error: e.message }.to_json)
      raise e
    end

    def task_payload_notification
      {
        notification: {
          task_id: @task.task_id,
          details: @task.results,
          status: @task.status,
          user_id: @task.user_id,
        }
      }
    end
  end
end
