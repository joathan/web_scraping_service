# frozen_string_literal: true

FactoryBot.define do
  factory :scrape_task do
    url { "http://example.com" }
    status { "pending" }
  end
end
