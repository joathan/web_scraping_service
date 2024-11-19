# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ScrapesController, type: :controller do
  let(:valid_url) { 'https://example.com' }

  describe 'POST /scrape' do
    it 'creates a new scraping task' do
      allow_any_instance_of(UrlValidator).to receive(:fetch_response).and_return(Net::HTTPSuccess.new(nil, '200', 'OK'))
      post :create, params: { scrape: { url: 'https://example.com' } }

      expect(response).to have_http_status(:created)
    end

    it 'returns an error for an invalid URL' do
      allow_any_instance_of(UrlValidator).to receive(:fetch_response).and_return(Net::HTTPNotFound.new(nil, '404', 'Not Found'))
      post :create, params: { scrape: { url: 'https://invalid-url.com' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /scrape/:task_id' do
    it 'returns the scraping task' do
      task = ScrapeTask.create!(url: valid_url, status: :pending)

      get :show, params: { id: task.id }

      expect(response).to have_http_status(:ok)
    end

    it 'returns an error when the task is not found' do
      get :show, params: { id: 0 }

      expect(response).to have_http_status(:not_found)
    end
  end
end
