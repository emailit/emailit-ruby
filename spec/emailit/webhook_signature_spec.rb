# frozen_string_literal: true

RSpec.describe Emailit::WebhookSignature do
  let(:secret) { "whsec_test_secret" }

  describe ".verify" do
    it "returns typed event with valid signature" do
      payload = JSON.generate({
        "event_id" => "evt_abc123",
        "type" => "email.delivered",
        "data" => { "object" => { "id" => "em_xyz" } },
      })
      timestamp = Time.now.to_i.to_s
      signature = described_class.compute_signature(payload, timestamp, secret)

      event = described_class.verify(payload, signature, timestamp, secret)

      expect(event).to be_a(Emailit::Events::EmailDelivered)
      expect(event.event_id).to eq("evt_abc123")
      expect(event.type).to eq("email.delivered")
    end

    it "raises on invalid signature" do
      payload = JSON.generate({ "event_id" => "evt_abc123", "type" => "email.delivered" })
      timestamp = Time.now.to_i.to_s

      expect {
        described_class.verify(payload, "invalid_signature_hex", timestamp, secret)
      }.to raise_error(Emailit::ApiError, "Webhook signature verification failed.")
    end

    it "raises when timestamp is too old" do
      payload = JSON.generate({ "event_id" => "evt_abc123", "type" => "email.delivered" })
      timestamp = (Time.now.to_i - 600).to_s
      signature = described_class.compute_signature(payload, timestamp, secret)

      expect {
        described_class.verify(payload, signature, timestamp, secret)
      }.to raise_error(Emailit::ApiError, /Webhook timestamp is too old/)
    end

    it "with nil tolerance skips age check" do
      payload = JSON.generate({
        "event_id" => "evt_old",
        "type" => "email.bounced",
        "data" => { "object" => { "id" => "em_1" } },
      })
      timestamp = (Time.now.to_i - 86400).to_s
      signature = described_class.compute_signature(payload, timestamp, secret)

      event = described_class.verify(payload, signature, timestamp, secret, tolerance: nil)

      expect(event).to be_a(Emailit::Events::WebhookEvent)
      expect(event.event_id).to eq("evt_old")
    end

    it "respects custom tolerance - rejects" do
      payload = JSON.generate({ "event_id" => "evt_test", "type" => "email.delivered" })
      timestamp = (Time.now.to_i - 120).to_s
      signature = described_class.compute_signature(payload, timestamp, secret)

      expect {
        described_class.verify(payload, signature, timestamp, secret, tolerance: 60)
      }.to raise_error(Emailit::ApiError, /Webhook timestamp is too old/)
    end

    it "passes with sufficient custom tolerance" do
      payload = JSON.generate({
        "event_id" => "evt_test",
        "type" => "email.delivered",
        "data" => { "object" => { "id" => "em_1" } },
      })
      timestamp = (Time.now.to_i - 120).to_s
      signature = described_class.compute_signature(payload, timestamp, secret)

      event = described_class.verify(payload, signature, timestamp, secret, tolerance: 300)

      expect(event).to be_a(Emailit::Events::EmailDelivered)
    end

    it "raises on invalid JSON body" do
      payload = "not-valid-json{{{"
      timestamp = Time.now.to_i.to_s
      signature = described_class.compute_signature(payload, timestamp, secret)

      expect {
        described_class.verify(payload, signature, timestamp, secret)
      }.to raise_error(Emailit::ApiError, /Invalid webhook payload/)
    end
  end

  describe ".compute_signature" do
    it "produces deterministic HMAC" do
      body = '{"event_id":"evt_123"}'
      timestamp = "1700000000"

      sig1 = described_class.compute_signature(body, timestamp, "test_secret")
      sig2 = described_class.compute_signature(body, timestamp, "test_secret")

      expect(sig1).to eq(sig2)
      expect(sig1.length).to eq(64)
    end

    it "changes with different secrets" do
      body = '{"event_id":"evt_123"}'
      timestamp = "1700000000"

      sig1 = described_class.compute_signature(body, timestamp, "secret_a")
      sig2 = described_class.compute_signature(body, timestamp, "secret_b")

      expect(sig1).not_to eq(sig2)
    end

    it "changes with different timestamps" do
      body = '{"event_id":"evt_123"}'

      sig1 = described_class.compute_signature(body, "1700000000", "test_secret")
      sig2 = described_class.compute_signature(body, "1700000001", "test_secret")

      expect(sig1).not_to eq(sig2)
    end
  end

  describe "constants" do
    it "defines header constants" do
      expect(described_class::HEADER_SIGNATURE).to eq("x-emailit-signature")
      expect(described_class::HEADER_TIMESTAMP).to eq("x-emailit-timestamp")
      expect(described_class::DEFAULT_TOLERANCE).to eq(300)
    end
  end
end
