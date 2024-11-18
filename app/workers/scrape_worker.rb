# frozen_string_literal: true

class ScrapeWorker
  include Sidekiq::Worker

  def perform(task_id)
    task = ScrapeTask.find(task_id)
    log_info("Starting scraping task", task_id: task.id, url: task.url)

    scrape_results = scrape(task.url)

    if scrape_results[:status] == :success
      task.update!(status: :completed, results: scrape_results[:data])
      notify_service(task)
    else
      task.update!(status: :failed)
      log_error("Scraping failed", task_id: task.id, url: task.url)
    end
  rescue StandardError => e
    task.update!(status: :failed) if task.persisted?
    log_error("Unexpected error during task execution", task_id: task_id, error: e.message)
    raise e
  end

  private

  def scrape(url)
    response = HTTParty.get(url)
    return { status: :failed } unless response.code == 200

    document = Nokogiri::HTML(response.body)
    { status: :success, data: parse_data(document) }
  rescue StandardError => e
    log_error("Scraping error", url: url, error: e.message)
    { status: :failed }
  end

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

  def notify_service(task)
    NotificationPublisher.new.publish(
      scrape_task_id: task.id,
      url: task.url,
      results: task.results
    )
    log_info("Notification sent", task_id: task.id)
  rescue StandardError => e
    log_error("Notification error", task_id: task.id, error: e.message)
    raise e
  end

  def log_info(message, details = {})
    Rails.logger.info({ message: message }.merge(details).to_json)
  end

  def log_error(message, details = {})
    Rails.logger.error({ message: message }.merge(details).to_json)
  end
end
