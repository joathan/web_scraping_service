# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScrapeTask, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
