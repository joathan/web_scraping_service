# frozen_string_literal: true

class CreateScrapeTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :scrape_tasks do |t|
      t.string :url
      t.integer :status
      t.json :results

      t.timestamps
    end
  end
end
