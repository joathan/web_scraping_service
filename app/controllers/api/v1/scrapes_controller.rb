# frozen_string_literal: true

module Api
  module V1
    class ScrapesController < ApplicationController
      before_action :validate_url, only: :create

      def create
        result = Scraping::CreatorService.call(scrape_params[:url])

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
        params.require(:scrape).permit(:url)
      end

      def validate_url
        uri = URI.parse(scrape_params[:url])
        render json: { error: 'Invalid URL' }, status: :unprocessable_entity unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      rescue URI::InvalidURIError
        render json: { error: 'Malformed URL' }, status: :unprocessable_entity
      end
    end
  end
end
