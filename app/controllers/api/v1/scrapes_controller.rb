# app/controllers/api/v1/scrapes_controller.rb
module Api
  module V1
    class ScrapesController < ApplicationController
      before_action :token, only: %i[create]

      def create
        Rails.logger.info "Creating scraping task for user: #{scrape_params[:user_id]}"
        result = Scraping::CreatorService.call(scrape_params, token)

        if result.is_a?(Hash) && result[:error]
          render json: { error: 'Failed to create scraping task', details: result[:error] }, status: :unprocessable_entity
        else
          render json: { task_id: result.id, message: 'Scraping task created!' }, status: :created
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
        params.require(:scrape).permit(:task_id, :url, :user_id)
      end

      def token
        request.headers['Authorization']&.split(' ')&.last
      end
    end
  end
end
