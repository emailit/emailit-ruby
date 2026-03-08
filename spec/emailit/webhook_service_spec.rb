# frozen_string_literal: true

RSpec.describe Emailit::Services::WebhookService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns a Webhook resource" do
      stub_api(:post, "/v2/webhooks", status: 201, body: {
        "object" => "webhook", "id" => "wh_abc", "name" => "My Webhook", "url" => "https://example.com/webhook",
      })

      webhook = client.webhooks.create(name: "My Webhook", url: "https://example.com/webhook")

      expect(webhook).to be_a(Emailit::Webhook)
      expect(webhook.id).to eq("wh_abc")
    end
  end

  describe "#get" do
    it "returns a Webhook resource" do
      stub_api(:get, "/v2/webhooks/wh_abc", body: {
        "object" => "webhook", "id" => "wh_abc", "name" => "My Webhook",
      })

      webhook = client.webhooks.get("wh_abc")

      expect(webhook).to be_a(Emailit::Webhook)
    end
  end

  describe "#update" do
    it "returns an updated Webhook resource" do
      stub_api(:post, "/v2/webhooks/wh_abc", body: {
        "object" => "webhook", "id" => "wh_abc", "name" => "Updated",
      })

      webhook = client.webhooks.update("wh_abc", name: "Updated")

      expect(webhook).to be_a(Emailit::Webhook)
      expect(webhook.name).to eq("Updated")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/webhooks", body: {
        "data" => [{ "object" => "webhook", "id" => "wh_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.webhooks.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(1)
    end
  end

  describe "#delete" do
    it "returns a Webhook resource" do
      stub_api(:delete, "/v2/webhooks/wh_abc", body: {
        "object" => "webhook", "id" => "wh_abc", "deleted" => true,
      })

      webhook = client.webhooks.delete("wh_abc")

      expect(webhook).to be_a(Emailit::Webhook)
    end
  end
end
