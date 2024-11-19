# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ScrapesController, type: :controller do
  let(:url) { 'https://www.icarros.com.br/comprar/maceio-al/fiat/palio/2016/d49889284' }

  describe 'POST /scrape' do
    it 'creates a new scraping task' do
      post :create, params: { scrape: { url: } }

      expect(response).to have_http_status(:created)
    end

    it 'returns an error when the URL is invalid' do
      post :create, params: { scrape: { url: 'invalid_url' } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /scrape/:task_id', vcr: true do
    it 'returns the scraping task' do
      task = ScrapeTask.create!(url:, status: :pending)
      get :show, params: { id: task.id }

      expect(response).to have_http_status(:ok)
    end

    it 'returns an error when the task is not found' do
      get :show, params: { id: 0 }

      expect(response).to have_http_status(:not_found)
    end
  end
end
