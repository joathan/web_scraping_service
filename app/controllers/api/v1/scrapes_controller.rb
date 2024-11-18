# frozen_string_literal: true

module Api
  module V1
    class ScrapesController < ApplicationController
      def create
        scrape_task = ScrapeTask.create!(scrape_params.merge(status: :pending))
        ScrapeWorker.perform_async(scrape_task.id)

        render json: { task_id: scrape_task.id, message: 'Scraping task created!' }, status: :created
      end

      def show
        scrape_task = ScrapeTask.find(params[:id])

        render json: scrape_task, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
      end

      private

      def scrape_params
        params.require(:scrape).permit(:url)
      end
    end
  end
end
