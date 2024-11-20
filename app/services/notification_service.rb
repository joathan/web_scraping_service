# frozen_string_literal: true

require 'net/http'

class NotificationService
  NOTIFICATION_SERVICE_URL = ENV.fetch('NOTIFICATION_SERVICE_URL', 'http://notifications_service:3000/api/v1/notifications').freeze

  def self.send_notification(notification_payload, user_token)
    response = ExternalService.post(NOTIFICATION_SERVICE_URL, notification_payload, user_token)

    if response
      Rails.logger.info "Notification sent successfully: #{notification_payload}"
      response
    else
      Rails.logger.error "Failed to send notification."
      nil
    end
  end
end
