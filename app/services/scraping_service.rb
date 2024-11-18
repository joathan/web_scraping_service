# frozen_string_literal: true

class ScrapingService
  def initialize(task)
    @task = task
  end

  def perform
    response = HTTParty.get(@task.url)

    return { status: :failed } unless response.code == 200

    document = Nokogiri::HTML(response.body)
    { status: :success, data: parse_data(document) }
  rescue StandardError => e
    Rails.logger.error({ message: "Scraping Error", task_id: @task.id, error: e.message }.to_json)
    { status: :failed }
  end

  private

  def parse_data(document)
    items = document.css('ul.listahorizontal li').map do |item|
      {
        label: item.at_css('h6')&.text&.strip,
        value: item.at_css('span.destaque')&.text&.strip
      }
    end.reject { |item| item[:label].nil? && item[:value].nil? }

    items << price(document)
  end

  def price(document)
    {
      label: 'Preço',
      value: document.at_css('.preco')&.text&.strip
    }
  end
end
