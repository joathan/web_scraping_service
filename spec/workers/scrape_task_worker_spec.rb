# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapeTaskWorker do
  let!(:tasks) { create_list(:scrape_task, 5, status: :pending) }

  xit 'processes all tasks and updates their statuses' do
    allow_any_instance_of(ScrapingService).to receive(:perform).and_return({ status: :success, data: { foo: 'bar' } })
    allow_any_instance_of(NotificationService).to receive(:notify)

    described_class.new.perform

    tasks.each do |task|
      expect(task.reload.status).to eq('completed')
      expect(task.results).to eq({ "foo" => "bar" })
    end
  end
end
