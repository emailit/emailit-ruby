# frozen_string_literal: true

module Emailit
  class EmailitClient < BaseClient
    def emails
      @emails ||= Services::EmailService.new(self)
    end

    def domains
      @domains ||= Services::DomainService.new(self)
    end

    def api_keys
      @api_keys ||= Services::ApiKeyService.new(self)
    end

    def audiences
      @audiences ||= Services::AudienceService.new(self)
    end

    def subscribers
      @subscribers ||= Services::SubscriberService.new(self)
    end

    def templates
      @templates ||= Services::TemplateService.new(self)
    end

    def suppressions
      @suppressions ||= Services::SuppressionService.new(self)
    end

    def email_verifications
      @email_verifications ||= Services::EmailVerificationService.new(self)
    end

    def email_verification_lists
      @email_verification_lists ||= Services::EmailVerificationListService.new(self)
    end

    def webhooks
      @webhooks ||= Services::WebhookService.new(self)
    end

    def contacts
      @contacts ||= Services::ContactService.new(self)
    end

    def events
      @events ||= Services::EventService.new(self)
    end
  end
end
