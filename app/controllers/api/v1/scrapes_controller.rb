# app/controllers/api/v1/scrapes_controller.rb
module Api
  module V1
    class ScrapesController < ApplicationController
      def create
        scrape_task = ScrapeTask.new(scrape_params)

        if scrape_task.save
          ScrapeWorker.perform_async(scrape_task.id)
          render json: { task_id: scrape_task.id, message: 'Scraping task created!' }, status: :created
        else
          render json: { error: 'Failed to create scraping task', details: scrape_task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        scrape_task = ScrapeTask.find(params[:id])
        render json: scrape_task, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found', task_id: params[:id] }, status: :not_found
      end

      private

      def scrape_params
        params.require(:scrape).permit(:url)
      end
    end
  end
end
