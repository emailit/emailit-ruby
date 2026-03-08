# frozen_string_literal: true

RSpec.describe Emailit::EmailitClient do
  it "accepts a string api key" do
    client = described_class.new("em_test_abc")
    expect(client.api_key).to eq("em_test_abc")
    expect(client.api_base).to eq(Emailit::BaseClient::DEFAULT_API_BASE)
  end

  it "accepts a config hash" do
    client = described_class.new(api_key: "em_test_xyz", api_base: "https://custom.emailit.com")
    expect(client.api_key).to eq("em_test_xyz")
    expect(client.api_base).to eq("https://custom.emailit.com")
  end

  it "accepts string keys in config hash" do
    client = described_class.new("api_key" => "em_test_str")
    expect(client.api_key).to eq("em_test_str")
  end

  it "strips trailing slash from api_base" do
    client = described_class.new(api_key: "em_test_key", api_base: "https://api.emailit.com/")
    expect(client.api_base).to eq("https://api.emailit.com")
  end

  it "raises on missing api_key" do
    expect { described_class.new(api_base: "https://api.emailit.com") }.to raise_error(ArgumentError, /api_key is required/)
  end

  it "raises on empty api_key string" do
    expect { described_class.new("") }.to raise_error(ArgumentError, /api_key is required/)
  end

  it "raises on empty api_key in hash" do
    expect { described_class.new(api_key: "") }.to raise_error(ArgumentError, /api_key is required/)
  end

  it "returns an EmailService from emails" do
    client = described_class.new("em_test_key")
    expect(client.emails).to be_a(Emailit::Services::EmailService)
  end

  it "caches service instances" do
    client = described_class.new("em_test_key")
    first = client.emails
    second = client.emails
    expect(first).to equal(second)
  end

  it "exposes all 12 services" do
    client = described_class.new("em_test_key")
    expect(client.emails).to be_a(Emailit::Services::EmailService)
    expect(client.domains).to be_a(Emailit::Services::DomainService)
    expect(client.api_keys).to be_a(Emailit::Services::ApiKeyService)
    expect(client.audiences).to be_a(Emailit::Services::AudienceService)
    expect(client.subscribers).to be_a(Emailit::Services::SubscriberService)
    expect(client.templates).to be_a(Emailit::Services::TemplateService)
    expect(client.suppressions).to be_a(Emailit::Services::SuppressionService)
    expect(client.email_verifications).to be_a(Emailit::Services::EmailVerificationService)
    expect(client.email_verification_lists).to be_a(Emailit::Services::EmailVerificationListService)
    expect(client.webhooks).to be_a(Emailit::Services::WebhookService)
    expect(client.contacts).to be_a(Emailit::Services::ContactService)
    expect(client.events).to be_a(Emailit::Services::EventService)
  end

  describe "Emailit.client" do
    it "returns an EmailitClient" do
      client = Emailit.client("em_test_facade")
      expect(client).to be_a(Emailit::EmailitClient)
      expect(client.api_key).to eq("em_test_facade")
    end
  end

  describe "Emailit::VERSION" do
    it "is defined" do
      expect(Emailit::VERSION).to eq("2.0.0")
    end
  end
end
