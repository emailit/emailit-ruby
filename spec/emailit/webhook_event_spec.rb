# frozen_string_literal: true

RSpec.describe Emailit::Events::WebhookEvent do
  describe ".construct_from" do
    it "returns typed event for all known event types" do
      types = {
        "email.accepted" => Emailit::Events::EmailAccepted,
        "email.scheduled" => Emailit::Events::EmailScheduled,
        "email.delivered" => Emailit::Events::EmailDelivered,
        "email.bounced" => Emailit::Events::EmailBounced,
        "email.attempted" => Emailit::Events::EmailAttempted,
        "email.failed" => Emailit::Events::EmailFailed,
        "email.rejected" => Emailit::Events::EmailRejected,
        "email.suppressed" => Emailit::Events::EmailSuppressed,
        "email.received" => Emailit::Events::EmailReceived,
        "email.complained" => Emailit::Events::EmailComplained,
        "email.clicked" => Emailit::Events::EmailClicked,
        "email.loaded" => Emailit::Events::EmailLoaded,
        "domain.created" => Emailit::Events::DomainCreated,
        "domain.updated" => Emailit::Events::DomainUpdated,
        "domain.deleted" => Emailit::Events::DomainDeleted,
        "audience.created" => Emailit::Events::AudienceCreated,
        "audience.updated" => Emailit::Events::AudienceUpdated,
        "audience.deleted" => Emailit::Events::AudienceDeleted,
        "subscriber.created" => Emailit::Events::SubscriberCreated,
        "subscriber.updated" => Emailit::Events::SubscriberUpdated,
        "subscriber.deleted" => Emailit::Events::SubscriberDeleted,
        "contact.created" => Emailit::Events::ContactCreated,
        "contact.updated" => Emailit::Events::ContactUpdated,
        "contact.deleted" => Emailit::Events::ContactDeleted,
        "template.created" => Emailit::Events::TemplateCreated,
        "template.updated" => Emailit::Events::TemplateUpdated,
        "template.deleted" => Emailit::Events::TemplateDeleted,
        "suppression.created" => Emailit::Events::SuppressionCreated,
        "suppression.updated" => Emailit::Events::SuppressionUpdated,
        "suppression.deleted" => Emailit::Events::SuppressionDeleted,
        "email_verification.created" => Emailit::Events::EmailVerificationCreated,
        "email_verification.updated" => Emailit::Events::EmailVerificationUpdated,
        "email_verification.deleted" => Emailit::Events::EmailVerificationDeleted,
        "email_verification_list.created" => Emailit::Events::EmailVerificationListCreated,
        "email_verification_list.updated" => Emailit::Events::EmailVerificationListUpdated,
        "email_verification_list.deleted" => Emailit::Events::EmailVerificationListDeleted,
      }

      types.each do |event_type, expected_class|
        event = described_class.construct_from({
          "event_id" => "evt_test",
          "type" => event_type,
          "data" => { "object" => { "id" => "test" } },
        })

        expect(event).to be_a(expected_class), "Failed for type: #{event_type}"
        expect(event).to be_a(Emailit::Events::WebhookEvent)
      end
    end

    it "returns generic WebhookEvent for unknown type" do
      event = described_class.construct_from({
        "event_id" => "evt_test",
        "type" => "unknown.event",
        "data" => { "object" => { "id" => "test" } },
      })

      expect(event).to be_a(Emailit::Events::WebhookEvent)
      expect(event.class).to eq(Emailit::Events::WebhookEvent)
      expect(event.type).to eq("unknown.event")
    end
  end

  describe "event property access" do
    it "exposes properties" do
      event = described_class.construct_from({
        "event_id" => "evt_abc123",
        "type" => "email.delivered",
        "data" => { "object" => { "id" => "em_xyz", "status" => "delivered" } },
      })

      expect(event).to be_a(Emailit::Events::EmailDelivered)
      expect(event.event_id).to eq("evt_abc123")
      expect(event.type).to eq("email.delivered")
      expect(event.data).to be_a(Hash)
    end
  end

  describe "#event_data" do
    it "returns the nested object" do
      event = described_class.construct_from({
        "event_id" => "evt_test",
        "type" => "email.delivered",
        "data" => { "object" => { "id" => "em_xyz", "status" => "delivered" } },
      })

      expect(event.event_data).to eq({ "id" => "em_xyz", "status" => "delivered" })
    end

    it "falls back to data when object key missing" do
      event = described_class.construct_from({
        "event_id" => "evt_test",
        "type" => "email.delivered",
        "data" => { "id" => "em_xyz" },
      })

      expect(event.event_data).to eq({ "id" => "em_xyz" })
    end

    it "returns nil when data is missing" do
      event = described_class.construct_from({
        "event_id" => "evt_test",
        "type" => "email.delivered",
      })

      expect(event.event_data).to be_nil
    end
  end

  describe "EVENT_TYPE constants" do
    it "defines correct EVENT_TYPE for all event classes" do
      expect(Emailit::Events::EmailAccepted::EVENT_TYPE).to eq("email.accepted")
      expect(Emailit::Events::EmailDelivered::EVENT_TYPE).to eq("email.delivered")
      expect(Emailit::Events::EmailBounced::EVENT_TYPE).to eq("email.bounced")
      expect(Emailit::Events::DomainCreated::EVENT_TYPE).to eq("domain.created")
      expect(Emailit::Events::AudienceDeleted::EVENT_TYPE).to eq("audience.deleted")
      expect(Emailit::Events::SubscriberUpdated::EVENT_TYPE).to eq("subscriber.updated")
      expect(Emailit::Events::ContactCreated::EVENT_TYPE).to eq("contact.created")
      expect(Emailit::Events::TemplateDeleted::EVENT_TYPE).to eq("template.deleted")
      expect(Emailit::Events::SuppressionCreated::EVENT_TYPE).to eq("suppression.created")
      expect(Emailit::Events::EmailVerificationCreated::EVENT_TYPE).to eq("email_verification.created")
      expect(Emailit::Events::EmailVerificationListDeleted::EVENT_TYPE).to eq("email_verification_list.deleted")
    end
  end

  describe "all event classes extend WebhookEvent" do
    it "inherits from WebhookEvent" do
      classes = [
        Emailit::Events::EmailAccepted, Emailit::Events::EmailScheduled,
        Emailit::Events::EmailDelivered, Emailit::Events::EmailBounced,
        Emailit::Events::EmailAttempted, Emailit::Events::EmailFailed,
        Emailit::Events::EmailRejected, Emailit::Events::EmailSuppressed,
        Emailit::Events::EmailReceived, Emailit::Events::EmailComplained,
        Emailit::Events::EmailClicked, Emailit::Events::EmailLoaded,
        Emailit::Events::DomainCreated, Emailit::Events::DomainUpdated,
        Emailit::Events::DomainDeleted,
        Emailit::Events::AudienceCreated, Emailit::Events::AudienceUpdated,
        Emailit::Events::AudienceDeleted,
        Emailit::Events::SubscriberCreated, Emailit::Events::SubscriberUpdated,
        Emailit::Events::SubscriberDeleted,
        Emailit::Events::ContactCreated, Emailit::Events::ContactUpdated,
        Emailit::Events::ContactDeleted,
        Emailit::Events::TemplateCreated, Emailit::Events::TemplateUpdated,
        Emailit::Events::TemplateDeleted,
        Emailit::Events::SuppressionCreated, Emailit::Events::SuppressionUpdated,
        Emailit::Events::SuppressionDeleted,
        Emailit::Events::EmailVerificationCreated, Emailit::Events::EmailVerificationUpdated,
        Emailit::Events::EmailVerificationDeleted,
        Emailit::Events::EmailVerificationListCreated, Emailit::Events::EmailVerificationListUpdated,
        Emailit::Events::EmailVerificationListDeleted,
      ]

      classes.each do |klass|
        expect(klass.new).to be_a(Emailit::Events::WebhookEvent), "Failed for: #{klass}"
      end
    end
  end

  describe "WebhookEvent supports array access and JSON serialization" do
    it "supports bracket access and to_json" do
      payload = {
        "event_id" => "evt_test",
        "type" => "email.delivered",
        "data" => { "object" => { "id" => "em_1" } },
      }

      event = described_class.construct_from(payload)

      expect(event["event_id"]).to eq("evt_test")
      expect(event["type"]).to eq("email.delivered")
      expect(event.to_json).to eq(JSON.generate(payload))
    end
  end
end
