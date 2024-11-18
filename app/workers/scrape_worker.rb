# frozen_string_literal: true

class ScrapeWorker
  include Sidekiq::Worker

  def perform(task_id)
    task = ScrapeTask.find(task_id)
    # TODO: Implementar o serviço de scraping
    # service = ScrapeService.new(task.url).perform
    response = HTTParty.get(task.url)

    if response.code == 200
      document = Nokogiri::HTML(response.body)
      results = parse_data(document)
      task.update!(status: :completed, results: results)
      
      # TODO: Implementar a notificação
      # notify_service(task)
    else
      task.update!(status: :failed)
    end
  end

  private

  def parse_data(document)
    r = document.css('ul.listahorizontal li').map do |item|
      {
        label: item.at_css('h6')&.text&.strip,
        value: item.at_css('span.destaque')&.text&.strip
      }
    end.reject { |item| item[:label].nil? && item[:value].nil? }

    r << price(document)
  end

  def price(document)
    {
      label: 'Preço',
      value: document.at_css('.preco')&.text&.strip
    }
  end

  def notify_service(task)
    NotificationPublisher.new.publish(
      {
        scrape_task_id: task.id,
        url: task.url,
        results: task.results
      }
    )
  end
end
