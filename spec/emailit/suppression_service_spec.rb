# frozen_string_literal: true

RSpec.describe Emailit::Services::SuppressionService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns a Suppression resource" do
      stub_api(:post, "/v2/suppressions", status: 201, body: {
        "object" => "suppression", "id" => "sup_abc", "email" => "bounced@example.com",
      })

      suppression = client.suppressions.create(email: "bounced@example.com")

      expect(suppression).to be_a(Emailit::Suppression)
      expect(suppression.id).to eq("sup_abc")
    end
  end

  describe "#get" do
    it "returns a Suppression resource" do
      stub_api(:get, "/v2/suppressions/sup_abc", body: {
        "object" => "suppression", "id" => "sup_abc", "email" => "bounced@example.com",
      })

      suppression = client.suppressions.get("sup_abc")

      expect(suppression).to be_a(Emailit::Suppression)
    end
  end

  describe "#update" do
    it "returns an updated Suppression resource" do
      stub_api(:post, "/v2/suppressions/sup_abc", body: {
        "object" => "suppression", "id" => "sup_abc", "reason" => "hard_bounce",
      })

      suppression = client.suppressions.update("sup_abc", reason: "hard_bounce")

      expect(suppression).to be_a(Emailit::Suppression)
      expect(suppression.reason).to eq("hard_bounce")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/suppressions", body: {
        "data" => [{ "object" => "suppression", "id" => "sup_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.suppressions.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(1)
    end
  end

  describe "#delete" do
    it "returns a Suppression resource" do
      stub_api(:delete, "/v2/suppressions/sup_abc", body: {
        "object" => "suppression", "id" => "sup_abc", "deleted" => true,
      })

      suppression = client.suppressions.delete("sup_abc")

      expect(suppression).to be_a(Emailit::Suppression)
    end
  end
end
