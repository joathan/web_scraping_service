# frozen_string_literal: true

require 'net/http'

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    uri = URI.parse(value)

    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      record.errors.add(attribute, 'is not a valid HTTP/HTTPS URL')
      return
    end

    response = fetch_response(uri)
    unless response.is_a?(Net::HTTPSuccess)
      record.errors.add(attribute, 'is not accessible or does not exist')
    end
  rescue URI::InvalidURIError
    record.errors.add(attribute, 'is malformed')
  rescue StandardError => e
    record.errors.add(attribute, "could not be validated: #{e.message}")
  end

  private

  def fetch_response(uri)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Head.new(uri)
      http.request(request)
    end
  end
end
