# frozen_string_literal: true

module Emailit
  module Events
    class WebhookEvent < EmailitObject
      EVENT_TYPE = ""

      def self.construct_from(payload)
        init_event_map unless @event_map_initialized

        type = payload["type"]

        if type && @event_map[type]
          @event_map[type].new(payload)
        else
          new(payload)
        end
      end

      def event_data
        data = @values["data"]
        return nil unless data

        data["object"] || data
      end

      def self.init_event_map
        @event_map = {
          "email.accepted" => EmailAccepted,
          "email.scheduled" => EmailScheduled,
          "email.delivered" => EmailDelivered,
          "email.bounced" => EmailBounced,
          "email.attempted" => EmailAttempted,
          "email.failed" => EmailFailed,
          "email.rejected" => EmailRejected,
          "email.suppressed" => EmailSuppressed,
          "email.received" => EmailReceived,
          "email.complained" => EmailComplained,
          "email.clicked" => EmailClicked,
          "email.loaded" => EmailLoaded,
          "domain.created" => DomainCreated,
          "domain.updated" => DomainUpdated,
          "domain.deleted" => DomainDeleted,
          "audience.created" => AudienceCreated,
          "audience.updated" => AudienceUpdated,
          "audience.deleted" => AudienceDeleted,
          "subscriber.created" => SubscriberCreated,
          "subscriber.updated" => SubscriberUpdated,
          "subscriber.deleted" => SubscriberDeleted,
          "contact.created" => ContactCreated,
          "contact.updated" => ContactUpdated,
          "contact.deleted" => ContactDeleted,
          "template.created" => TemplateCreated,
          "template.updated" => TemplateUpdated,
          "template.deleted" => TemplateDeleted,
          "suppression.created" => SuppressionCreated,
          "suppression.updated" => SuppressionUpdated,
          "suppression.deleted" => SuppressionDeleted,
          "email_verification.created" => EmailVerificationCreated,
          "email_verification.updated" => EmailVerificationUpdated,
          "email_verification.deleted" => EmailVerificationDeleted,
          "email_verification_list.created" => EmailVerificationListCreated,
          "email_verification_list.updated" => EmailVerificationListUpdated,
          "email_verification_list.deleted" => EmailVerificationListDeleted,
        }
        @event_map_initialized = true
      end
      private_class_method :init_event_map
    end

    class EmailAccepted < WebhookEvent
      EVENT_TYPE = "email.accepted"
    end

    class EmailScheduled < WebhookEvent
      EVENT_TYPE = "email.scheduled"
    end

    class EmailDelivered < WebhookEvent
      EVENT_TYPE = "email.delivered"
    end

    class EmailBounced < WebhookEvent
      EVENT_TYPE = "email.bounced"
    end

    class EmailAttempted < WebhookEvent
      EVENT_TYPE = "email.attempted"
    end

    class EmailFailed < WebhookEvent
      EVENT_TYPE = "email.failed"
    end

    class EmailRejected < WebhookEvent
      EVENT_TYPE = "email.rejected"
    end

    class EmailSuppressed < WebhookEvent
      EVENT_TYPE = "email.suppressed"
    end

    class EmailReceived < WebhookEvent
      EVENT_TYPE = "email.received"
    end

    class EmailComplained < WebhookEvent
      EVENT_TYPE = "email.complained"
    end

    class EmailClicked < WebhookEvent
      EVENT_TYPE = "email.clicked"
    end

    class EmailLoaded < WebhookEvent
      EVENT_TYPE = "email.loaded"
    end

    class DomainCreated < WebhookEvent
      EVENT_TYPE = "domain.created"
    end

    class DomainUpdated < WebhookEvent
      EVENT_TYPE = "domain.updated"
    end

    class DomainDeleted < WebhookEvent
      EVENT_TYPE = "domain.deleted"
    end

    class AudienceCreated < WebhookEvent
      EVENT_TYPE = "audience.created"
    end

    class AudienceUpdated < WebhookEvent
      EVENT_TYPE = "audience.updated"
    end

    class AudienceDeleted < WebhookEvent
      EVENT_TYPE = "audience.deleted"
    end

    class SubscriberCreated < WebhookEvent
      EVENT_TYPE = "subscriber.created"
    end

    class SubscriberUpdated < WebhookEvent
      EVENT_TYPE = "subscriber.updated"
    end

    class SubscriberDeleted < WebhookEvent
      EVENT_TYPE = "subscriber.deleted"
    end

    class ContactCreated < WebhookEvent
      EVENT_TYPE = "contact.created"
    end

    class ContactUpdated < WebhookEvent
      EVENT_TYPE = "contact.updated"
    end

    class ContactDeleted < WebhookEvent
      EVENT_TYPE = "contact.deleted"
    end

    class TemplateCreated < WebhookEvent
      EVENT_TYPE = "template.created"
    end

    class TemplateUpdated < WebhookEvent
      EVENT_TYPE = "template.updated"
    end

    class TemplateDeleted < WebhookEvent
      EVENT_TYPE = "template.deleted"
    end

    class SuppressionCreated < WebhookEvent
      EVENT_TYPE = "suppression.created"
    end

    class SuppressionUpdated < WebhookEvent
      EVENT_TYPE = "suppression.updated"
    end

    class SuppressionDeleted < WebhookEvent
      EVENT_TYPE = "suppression.deleted"
    end

    class EmailVerificationCreated < WebhookEvent
      EVENT_TYPE = "email_verification.created"
    end

    class EmailVerificationUpdated < WebhookEvent
      EVENT_TYPE = "email_verification.updated"
    end

    class EmailVerificationDeleted < WebhookEvent
      EVENT_TYPE = "email_verification.deleted"
    end

    class EmailVerificationListCreated < WebhookEvent
      EVENT_TYPE = "email_verification_list.created"
    end

    class EmailVerificationListUpdated < WebhookEvent
      EVENT_TYPE = "email_verification_list.updated"
    end

    class EmailVerificationListDeleted < WebhookEvent
      EVENT_TYPE = "email_verification_list.deleted"
    end
  end
end
