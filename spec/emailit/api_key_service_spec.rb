# frozen_string_literal: true

RSpec.describe Emailit::Services::ApiKeyService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns an ApiKey resource" do
      stub_api(:post, "/v2/api-keys", status: 201, body: {
        "object" => "api_key", "id" => "key_abc", "name" => "Production",
      })

      key = client.api_keys.create(name: "Production")

      expect(key).to be_a(Emailit::ApiKey)
      expect(key.id).to eq("key_abc")
      expect(key.name).to eq("Production")
    end
  end

  describe "#get" do
    it "returns an ApiKey resource" do
      stub_api(:get, "/v2/api-keys/key_abc", body: {
        "object" => "api_key", "id" => "key_abc", "name" => "Production",
      })

      key = client.api_keys.get("key_abc")

      expect(key).to be_a(Emailit::ApiKey)
      expect(key.id).to eq("key_abc")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/api-keys", body: {
        "data" => [{ "object" => "api_key", "id" => "key_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.api_keys.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(1)
    end
  end

  describe "#update" do
    it "returns an updated ApiKey resource" do
      stub_api(:post, "/v2/api-keys/key_abc", body: {
        "object" => "api_key", "id" => "key_abc", "name" => "Staging",
      })

      key = client.api_keys.update("key_abc", name: "Staging")

      expect(key).to be_a(Emailit::ApiKey)
      expect(key.name).to eq("Staging")
    end
  end

  describe "#delete" do
    it "returns an ApiKey resource" do
      stub_api(:delete, "/v2/api-keys/key_abc", body: {
        "object" => "api_key", "id" => "key_abc", "deleted" => true,
      })

      key = client.api_keys.delete("key_abc")

      expect(key).to be_a(Emailit::ApiKey)
    end
  end
end
