# frozen_string_literal: true

require "mail"
require "emailit/delivery_method"

RSpec.describe Emailit::DeliveryMethod do
  it "raises without api_key" do
    expect { described_class.new({}) }.to raise_error(ArgumentError, /API key is required/)
  end

  it "delivers a simple text email" do
    stub_api(:post, "/v2/emails", status: 201, body: {
      "object" => "email", "id" => "em_123", "status" => "pending",
    })

    delivery = described_class.new(api_key: "em_test_key")

    mail = Mail.new do
      from "sender@example.com"
      to "recipient@example.com"
      subject "Test"
      body "Hello, world!"
    end

    delivery.deliver!(mail)

    expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails").with { |req|
      body = JSON.parse(req.body)
      body["from"] == "sender@example.com" &&
        body["to"] == ["recipient@example.com"] &&
        body["subject"] == "Test" &&
        body["text"] == "Hello, world!"
    }
  end

  it "delivers a multipart email with html and text" do
    stub_api(:post, "/v2/emails", status: 201, body: {
      "object" => "email", "id" => "em_123", "status" => "pending",
    })

    delivery = described_class.new(api_key: "em_test_key")

    mail = Mail.new do
      from "sender@example.com"
      to "recipient@example.com"
      subject "Multipart"

      text_part do
        body "Plain text"
      end

      html_part do
        content_type "text/html; charset=UTF-8"
        body "<h1>HTML</h1>"
      end
    end

    delivery.deliver!(mail)

    expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails").with { |req|
      body = JSON.parse(req.body)
      body["text"] == "Plain text" && body["html"] == "<h1>HTML</h1>"
    }
  end

  it "delivers with cc and bcc" do
    stub_api(:post, "/v2/emails", status: 201, body: {
      "object" => "email", "id" => "em_123", "status" => "pending",
    })

    delivery = described_class.new(api_key: "em_test_key")

    mail = Mail.new do
      from "sender@example.com"
      to "recipient@example.com"
      cc "cc@example.com"
      bcc "bcc@example.com"
      subject "CC/BCC Test"
      body "Hello"
    end

    delivery.deliver!(mail)

    expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails").with { |req|
      body = JSON.parse(req.body)
      body["cc"] == ["cc@example.com"] && body["bcc"] == ["bcc@example.com"]
    }
  end

  it "delivers with reply_to" do
    stub_api(:post, "/v2/emails", status: 201, body: {
      "object" => "email", "id" => "em_123", "status" => "pending",
    })

    delivery = described_class.new(api_key: "em_test_key")

    mail = Mail.new do
      from "sender@example.com"
      to "recipient@example.com"
      reply_to "reply@example.com"
      subject "Reply-to Test"
      body "Hello"
    end

    delivery.deliver!(mail)

    expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails").with { |req|
      body = JSON.parse(req.body)
      body["reply_to"] == "reply@example.com"
    }
  end

  it "delivers with attachments" do
    stub_api(:post, "/v2/emails", status: 201, body: {
      "object" => "email", "id" => "em_123", "status" => "pending",
    })

    delivery = described_class.new(api_key: "em_test_key")

    mail = Mail.new do
      from "sender@example.com"
      to "recipient@example.com"
      subject "Attachment Test"
      body "See attached"
      add_file filename: "test.txt", content: "file content"
    end

    delivery.deliver!(mail)

    expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails").with { |req|
      body = JSON.parse(req.body)
      body["attachments"]&.length == 1 &&
        body["attachments"][0]["filename"] == "test.txt"
    }
  end
end
