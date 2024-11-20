# frozen_string_literal: true

require 'net/http'

class AuthenticationService
  AUTH_SERVICE_URL = ENV.fetch('AUTH_SERVICE_URL', 'http://auth_service:3000/api/v1/verify_token')

  def self.verify_token(token)
    uri = URI(AUTH_SERVICE_URL)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{token}"

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    JSON.parse(response.body, symbolize_names: true) if response.code == '200'
  rescue StandardError => e
    Rails.logger.error "Error communicating with AuthService: #{e.message}"
    nil
  end
end
