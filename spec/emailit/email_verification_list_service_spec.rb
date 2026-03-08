# frozen_string_literal: true

RSpec.describe Emailit::Services::EmailVerificationListService do
  let(:client) { mock_client }

  describe "#create" do
    it "returns an EmailVerificationList resource" do
      stub_api(:post, "/v2/email-verification-lists", status: 201, body: {
        "object" => "email_verification_list", "id" => "evl_abc", "name" => "Batch 1",
      })

      list = client.email_verification_lists.create(name: "Batch 1", emails: ["a@b.com"])

      expect(list).to be_a(Emailit::EmailVerificationList)
      expect(list.id).to eq("evl_abc")
    end
  end

  describe "#list" do
    it "returns a Collection" do
      stub_api(:get, "/v2/email-verification-lists", body: {
        "data" => [{ "object" => "email_verification_list", "id" => "evl_1" }],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.email_verification_lists.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(1)
    end
  end

  describe "#get" do
    it "returns an EmailVerificationList resource" do
      stub_api(:get, "/v2/email-verification-lists/evl_abc", body: {
        "object" => "email_verification_list", "id" => "evl_abc", "name" => "Batch 1",
      })

      evl = client.email_verification_lists.get("evl_abc")

      expect(evl).to be_a(Emailit::EmailVerificationList)
    end
  end

  describe "#results" do
    it "returns a Collection" do
      stub_api(:get, "/v2/email-verification-lists/evl_abc/results", body: {
        "data" => [
          { "email" => "a@b.com", "result" => "valid" },
          { "email" => "c@d.com", "result" => "invalid" },
        ],
        "next_page_url" => nil, "previous_page_url" => nil,
      })

      results = client.email_verification_lists.results("evl_abc")

      expect(results).to be_a(Emailit::Collection)
      expect(results.count).to eq(2)
    end
  end

  describe "#export" do
    it "returns raw ApiResponse" do
      stub_api_raw(:get, "/v2/email-verification-lists/evl_abc/export",
        status: 200,
        body: "binary-xlsx-content",
        headers: { "Content-Type" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
      )

      response = client.email_verification_lists.export("evl_abc")

      expect(response).to be_a(Emailit::ApiResponse)
      expect(response.body).to eq("binary-xlsx-content")
    end
  end
end
