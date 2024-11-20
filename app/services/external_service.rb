# frozen_string_literal: true

require 'net/http'

class ExternalService
  def self.post(url, payload, user_token = nil)
    uri = URI(url)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{user_token}" if user_token
    request.body = payload.to_json

    execute_request(uri, request)
  end

  def self.get(url, user_token = nil)
    uri = URI(url)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{user_token}" if user_token

    execute_request(uri, request)
  end

  private

  def self.execute_request(uri, request)
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    case response.code.to_i
    when 200..299
      Rails.logger.info "Request successful: #{response.body}"
      JSON.parse(response.body, symbolize_names: true)
    else
      Rails.logger.error "Request failed: #{response.code} - #{response.body}"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Error during request: #{e.message}"
    nil
  end
end
