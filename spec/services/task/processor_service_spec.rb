# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::ProcessorService do
  let(:task) { create(:scrape_task, status: :pending, url: 'https://example.com') }
  let(:service) { described_class.new(task) }

  it 'processes a task successfully' do
    allow(ScrapingService).to receive(:new).and_return(double(perform: { status: :success, data: { foo: 'bar' } }))

    expect { service.process }.to change { task.reload.status }.from('pending').to('completed')
  end

  it 'handles task failure' do
    allow(ScrapingService).to receive(:new).and_return(double(perform: { status: :failed }))

    expect { service.process }.to change { task.reload.status }.from('pending').to('failed')
  end
end
