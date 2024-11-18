# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapeTaskWorker do
  let!(:tasks) { create_list(:scrape_task, 5, status: :pending) }

  it 'processes all tasks using TaskProcessorService' do
    tasks.each do |task|
      processor_service = instance_double(Task::ProcessorService)

      expect(Task::ProcessorService).to receive(:new).with(task).and_return(processor_service)
      expect(processor_service).to receive(:process)
    end

    described_class.new.perform
  end
end
