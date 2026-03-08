# frozen_string_literal: true

RSpec.describe Emailit::Services::DomainService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns a Domain resource" do
      stub_api(:post, "/v2/domains", status: 201, body: {
        "object" => "domain", "id" => "dom_abc", "name" => "example.com",
      })

      domain = client.domains.create(name: "example.com")

      expect(domain).to be_a(Emailit::Domain)
      expect(domain.id).to eq("dom_abc")
      expect(domain.name).to eq("example.com")
    end
  end

  describe "#get" do
    it "returns a Domain resource" do
      stub_api(:get, "/v2/domains/dom_abc", body: {
        "object" => "domain", "id" => "dom_abc", "name" => "example.com",
      })

      domain = client.domains.get("dom_abc")

      expect(domain).to be_a(Emailit::Domain)
      expect(domain.id).to eq("dom_abc")
    end
  end

  describe "#verify" do
    it "returns a Domain resource" do
      stub_api(:post, "/v2/domains/dom_abc/verify", body: {
        "object" => "domain", "id" => "dom_abc", "verified" => true,
      })

      domain = client.domains.verify("dom_abc")

      expect(domain).to be_a(Emailit::Domain)
      expect(domain.verified).to be true
    end
  end

  describe "#update" do
    it "uses PATCH and returns a Domain resource" do
      stub_api(:patch, "/v2/domains/dom_abc", body: {
        "object" => "domain", "id" => "dom_abc", "track_clicks" => true,
      })

      domain = client.domains.update("dom_abc", track_clicks: true)

      expect(domain).to be_a(Emailit::Domain)
      expect(WebMock).to have_requested(:patch, "#{API_BASE}/v2/domains/dom_abc")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/domains", body: {
        "data" => [
          { "object" => "domain", "id" => "dom_1" },
          { "object" => "domain", "id" => "dom_2" },
        ],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.domains.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(2)
    end
  end

  describe "#delete" do
    it "returns a Domain resource" do
      stub_api(:delete, "/v2/domains/dom_abc", body: {
        "object" => "domain", "id" => "dom_abc", "deleted" => true,
      })

      domain = client.domains.delete("dom_abc")

      expect(domain).to be_a(Emailit::Domain)
    end
  end
end
