# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationService do
  let(:task) { ScrapeTask.new(id: 1, url: 'https://example.com', results: { foo: 'bar' }) }
  let(:publisher) { instance_double('Notification::PublisherService') }

  before do
    allow(Notification::PublisherService).to receive(:new).and_return(publisher)
  end

  it 'logs an error and raises an exception when publish fails' do
    allow(publisher).to receive(:publish).and_raise(StandardError, 'Publishing failed')

    expect(Rails.logger).to receive(:error).with(
      "{\"message\":\"Notification Error\",\"task_id\":1,\"error\":\"Publishing failed\"}"
    )

    service = NotificationService.new(task)
    expect { service.notify }.to raise_error(StandardError, 'Publishing failed')
  end
end
