# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last
    auth_response = AuthenticationService.verify_token(token)

    if auth_response
      @current_user ||= auth_response
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
