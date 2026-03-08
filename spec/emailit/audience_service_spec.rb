# frozen_string_literal: true

RSpec.describe Emailit::Services::AudienceService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns an Audience resource" do
      stub_api(:post, "/v2/audiences", status: 201, body: {
        "object" => "audience", "id" => "aud_abc", "name" => "Newsletter",
      })

      audience = client.audiences.create(name: "Newsletter")

      expect(audience).to be_a(Emailit::Audience)
      expect(audience.id).to eq("aud_abc")
    end
  end

  describe "#get" do
    it "returns an Audience resource" do
      stub_api(:get, "/v2/audiences/aud_abc", body: {
        "object" => "audience", "id" => "aud_abc", "name" => "Newsletter",
      })

      audience = client.audiences.get("aud_abc")

      expect(audience).to be_a(Emailit::Audience)
    end
  end

  describe "#update" do
    it "returns an updated Audience resource" do
      stub_api(:post, "/v2/audiences/aud_abc", body: {
        "object" => "audience", "id" => "aud_abc", "name" => "Updated",
      })

      audience = client.audiences.update("aud_abc", name: "Updated")

      expect(audience).to be_a(Emailit::Audience)
      expect(audience.name).to eq("Updated")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/audiences", body: {
        "data" => [{ "object" => "audience", "id" => "aud_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.audiences.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(1)
    end
  end

  describe "#delete" do
    it "returns an Audience resource" do
      stub_api(:delete, "/v2/audiences/aud_abc", body: {
        "object" => "audience", "id" => "aud_abc", "deleted" => true,
      })

      audience = client.audiences.delete("aud_abc")

      expect(audience).to be_a(Emailit::Audience)
    end
  end
end
