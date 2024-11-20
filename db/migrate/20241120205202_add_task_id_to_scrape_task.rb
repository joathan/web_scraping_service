# frozen_string_literal: true

class AddTaskIdToScrapeTask < ActiveRecord::Migration[7.1]
  def change
    add_column :scrape_tasks, :task_id, :integer
  end
end
