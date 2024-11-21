# frozen_string_literal: true

class ScrapeTask < ApplicationRecord
  enum status: { pending: 0, completed: 1, in_progress: 2, failed: 3 }, _default: "pending"

  validates :url, presence: true, url: true
  validates :status, presence: true

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :pending
  end
end
