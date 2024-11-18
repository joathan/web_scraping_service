# frozen_string_literal: true

class ScrapeTask < ApplicationRecord
  enum status: { pending: 0, completed: 1, failed: 2 }

  validates :url, presence: true
  validates :status, presence: true
end
