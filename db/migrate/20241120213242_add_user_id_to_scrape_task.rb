# frozen_string_literal: true

class AddUserIdToScrapeTask < ActiveRecord::Migration[7.1]
  def change
    add_column :scrape_tasks, :user_id, :integer
  end
end
