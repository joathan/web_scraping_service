# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapeWorker do
  let(:task) { create(:scrape_task, status: :pending) }

  it 'processes the task using TaskProcessorService' do
    expect_any_instance_of(Task::ProcessorService).to receive(:process)

    described_class.new.perform(task.id)
  end
end
