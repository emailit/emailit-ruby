# frozen_string_literal: true

RSpec.describe Emailit::Services::EmailVerificationService do
  let(:client) { mock_client }

  describe "#verify" do
    it "returns an EmailVerification resource" do
      stub_api(:post, "/v2/email-verifications", body: {
        "object" => "email_verification",
        "email" => "test@example.com",
        "result" => "valid",
        "score" => 95,
      })

      result = client.email_verifications.verify(email: "test@example.com")

      expect(result).to be_a(Emailit::EmailVerification)
      expect(result.email).to eq("test@example.com")
      expect(result.result).to eq("valid")
      expect(result.score).to eq(95)
    end
  end
end
