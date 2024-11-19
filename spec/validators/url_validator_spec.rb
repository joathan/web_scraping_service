# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlValidator do
  let(:model) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :url

      validates :url, url: true
    end.new
  end

  it 'is valid with a reachable URL' do
    allow_any_instance_of(UrlValidator).to receive(:fetch_response).and_return(Net::HTTPSuccess.new(nil, 200, 'OK'))
    model.url = 'https://example.com'

    expect(model).to be_valid
  end

  it 'is invalid with an unreachable URL' do
    allow_any_instance_of(UrlValidator).to receive(:fetch_response).and_return(Net::HTTPNotFound.new(nil, 404, 'Not Found'))
    model.url = 'https://invalid-url.com'

    expect(model).not_to be_valid
  end

  it 'is invalid with a malformed URL' do
    model.url = 'htp:/malformed-url'

    expect(model).not_to be_valid
  end

  it 'is invalid with an unsupported URL scheme' do
    model.url = 'ftp://example.com'

    expect(model).not_to be_valid
  end

  it 'is invalid with a URL that raises an error' do
    allow_any_instance_of(UrlValidator).to receive(:fetch_response).and_raise(StandardError)
    model.url = 'https://example.com'

    expect(model).not_to be_valid
  end
end
