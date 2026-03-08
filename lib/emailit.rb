# frozen_string_literal: true

require "json"
require "cgi"

require_relative "emailit/version"
require_relative "emailit/errors"
require_relative "emailit/api_response"
require_relative "emailit/emailit_object"
require_relative "emailit/api_resource"
require_relative "emailit/collection"
require_relative "emailit/util"

require_relative "emailit/resources/email"
require_relative "emailit/resources/domain"
require_relative "emailit/resources/api_key"
require_relative "emailit/resources/audience"
require_relative "emailit/resources/subscriber"
require_relative "emailit/resources/template"
require_relative "emailit/resources/suppression"
require_relative "emailit/resources/email_verification"
require_relative "emailit/resources/email_verification_list"
require_relative "emailit/resources/webhook"
require_relative "emailit/resources/contact"
require_relative "emailit/resources/event"

require_relative "emailit/services/base_service"
require_relative "emailit/services/email_service"
require_relative "emailit/services/domain_service"
require_relative "emailit/services/api_key_service"
require_relative "emailit/services/audience_service"
require_relative "emailit/services/subscriber_service"
require_relative "emailit/services/template_service"
require_relative "emailit/services/suppression_service"
require_relative "emailit/services/email_verification_service"
require_relative "emailit/services/email_verification_list_service"
require_relative "emailit/services/webhook_service"
require_relative "emailit/services/contact_service"
require_relative "emailit/services/event_service"

require_relative "emailit/events/webhook_event"

require_relative "emailit/webhook_signature"
require_relative "emailit/base_client"
require_relative "emailit/emailit_client"

module Emailit
  def self.client(api_key)
    EmailitClient.new(api_key)
  end

  Util.register_object_type(Email::OBJECT_NAME, Email)
  Util.register_object_type(Domain::OBJECT_NAME, Domain)
  Util.register_object_type(ApiKey::OBJECT_NAME, ApiKey)
  Util.register_object_type(Audience::OBJECT_NAME, Audience)
  Util.register_object_type(Subscriber::OBJECT_NAME, Subscriber)
  Util.register_object_type(Template::OBJECT_NAME, Template)
  Util.register_object_type(Suppression::OBJECT_NAME, Suppression)
  Util.register_object_type(EmailVerification::OBJECT_NAME, EmailVerification)
  Util.register_object_type(EmailVerificationList::OBJECT_NAME, EmailVerificationList)
  Util.register_object_type(Webhook::OBJECT_NAME, Webhook)
  Util.register_object_type(Contact::OBJECT_NAME, Contact)
  Util.register_object_type(Event::OBJECT_NAME, Event)
end

require_relative "emailit/railtie" if defined?(Rails::Railtie)
