# frozen_string_literal: true

class AddErrorMessageToScrapeTask < ActiveRecord::Migration[7.1]
  def change
    add_column :scrape_tasks, :error_message, :string
  end
end
