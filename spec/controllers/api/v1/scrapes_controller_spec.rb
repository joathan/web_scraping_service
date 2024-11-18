# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ScrapesController, type: :controller do
  let(:url) { 'https://www.icarros.com.br/comprar/maceio-al/fiat/palio/2016/d49889284' }

  describe 'POST /scrape' do
    it 'creates a new scraping task' do
      post :create, params: { scrape: { url: } }

      expect(response).to have_http_status(:created)
    end
  end

  describe 'GET /scrape/:task_id', vcr: true do
    it 'returns the scraping task' do
      task = ScrapeTask.create!(url:, status: :pending)
      get :show, params: { id: task.id }

      expect(response).to have_http_status(:ok)
    end
  end
end
