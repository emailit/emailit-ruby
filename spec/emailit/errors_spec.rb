# frozen_string_literal: true

RSpec.describe Emailit::ApiError do
  describe ".from_response" do
    it "returns AuthenticationError for 401" do
      error = described_class.from_response("Unauthorized", http_status: 401, http_body: "", json_body: nil, http_headers: {})
      expect(error).to be_a(Emailit::AuthenticationError)
      expect(error.message).to eq("Unauthorized")
      expect(error.http_status).to eq(401)
    end

    it "returns InvalidRequestError for 400" do
      error = described_class.from_response("Bad request", http_status: 400, http_body: "", json_body: nil, http_headers: {})
      expect(error).to be_a(Emailit::InvalidRequestError)
    end

    it "returns InvalidRequestError for 404" do
      error = described_class.from_response("Not found", http_status: 404, http_body: "", json_body: nil, http_headers: {})
      expect(error).to be_a(Emailit::InvalidRequestError)
    end

    it "returns RateLimitError for 429" do
      error = described_class.from_response("Rate limited", http_status: 429, http_body: "", json_body: nil, http_headers: {})
      expect(error).to be_a(Emailit::RateLimitError)
    end

    it "returns UnprocessableEntityError for 422" do
      error = described_class.from_response("Unprocessable", http_status: 422, http_body: "", json_body: nil, http_headers: {})
      expect(error).to be_a(Emailit::UnprocessableEntityError)
    end

    it "returns generic ApiError for other status codes" do
      error = described_class.from_response("Server error", http_status: 500, http_body: "", json_body: nil, http_headers: {})
      expect(error).to be_a(Emailit::ApiError)
      expect(error.class).to eq(Emailit::ApiError)
    end

    it "carries full response data" do
      body = '{"error":"test"}'
      json = { "error" => "test" }
      headers = { "x-request-id" => "req_123" }

      error = described_class.from_response("test", http_status: 500, http_body: body, json_body: json, http_headers: headers)

      expect(error.http_status).to eq(500)
      expect(error.http_body).to eq(body)
      expect(error.json_body).to eq(json)
      expect(error.http_headers).to eq(headers)
    end
  end

  describe "error hierarchy" do
    it "all errors inherit from Emailit::Error" do
      expect(Emailit::ApiError.ancestors).to include(Emailit::Error)
      expect(Emailit::AuthenticationError.ancestors).to include(Emailit::Error)
      expect(Emailit::InvalidRequestError.ancestors).to include(Emailit::Error)
      expect(Emailit::RateLimitError.ancestors).to include(Emailit::Error)
      expect(Emailit::UnprocessableEntityError.ancestors).to include(Emailit::Error)
      expect(Emailit::ConnectionError.ancestors).to include(Emailit::Error)
    end

    it "all api errors inherit from ApiError" do
      expect(Emailit::AuthenticationError.ancestors).to include(Emailit::ApiError)
      expect(Emailit::InvalidRequestError.ancestors).to include(Emailit::ApiError)
      expect(Emailit::RateLimitError.ancestors).to include(Emailit::ApiError)
      expect(Emailit::UnprocessableEntityError.ancestors).to include(Emailit::ApiError)
    end

    it "Emailit::Error inherits from StandardError" do
      expect(Emailit::Error.ancestors).to include(StandardError)
    end
  end
end
