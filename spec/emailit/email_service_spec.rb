# frozen_string_literal: true

RSpec.describe Emailit::Services::EmailService do
  let(:client) { mock_client }

  describe "#send" do
    it "returns an Email resource" do
      stub_api(:post, "/v2/emails", status: 201, body: {
        "object" => "email",
        "id" => "em_abc123",
        "status" => "pending",
        "from" => "hello@example.com",
        "to" => ["user@example.com"],
        "subject" => "Hello World",
      })

      email = client.emails.send(
        from: "hello@example.com",
        to: ["user@example.com"],
        subject: "Hello World",
        html: "<h1>Welcome!</h1>"
      )

      expect(email).to be_a(Emailit::Email)
      expect(email.id).to eq("em_abc123")
      expect(email.status).to eq("pending")
      expect(email.from).to eq("hello@example.com")
      expect(email.to).to eq(["user@example.com"])
      expect(email.subject).to eq("Hello World")
      expect(email["id"]).to eq("em_abc123")
    end

    it "sends with template and variables" do
      stub = stub_api(:post, "/v2/emails", status: 201, body: {
        "object" => "email", "id" => "em_tpl1", "status" => "pending",
      })

      email = client.emails.send(
        from: "hello@example.com",
        to: "user@example.com",
        template: "welcome_email",
        variables: { name: "John", company: "Acme" }
      )

      expect(email).to be_a(Emailit::Email)
      expect(email.id).to eq("em_tpl1")
    end

    it "sends with attachments" do
      stub_api(:post, "/v2/emails", status: 201, body: {
        "object" => "email", "id" => "em_att1", "status" => "pending",
      })

      client.emails.send(
        from: "invoices@example.com",
        to: "customer@example.com",
        subject: "Invoice",
        html: "<p>See attached.</p>",
        attachments: [
          { filename: "invoice.pdf", content: "base64data", content_type: "application/pdf" },
        ]
      )

      expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails")
        .with { |req| JSON.parse(req.body)["attachments"].length == 1 }
    end

    it "sends with scheduled_at" do
      stub_api(:post, "/v2/emails", status: 201, body: {
        "object" => "email", "id" => "em_sch1", "status" => "scheduled",
      })

      email = client.emails.send(
        from: "reminders@example.com",
        to: "user@example.com",
        subject: "Reminder",
        html: "<p>Tomorrow at 2 PM.</p>",
        scheduled_at: "2026-01-10T09:00:00Z"
      )

      expect(email.status).to eq("scheduled")
    end

    it "sends with tracking options" do
      stub_api(:post, "/v2/emails", status: 201, body: {
        "object" => "email", "id" => "em_trk1", "status" => "pending",
      })

      client.emails.send(
        from: "hello@example.com",
        to: ["user@example.com"],
        subject: "Tracked",
        html: "<p>Hi</p>",
        tracking: { loads: true, clicks: true }
      )

      expect(WebMock).to have_requested(:post, "#{API_BASE}/v2/emails")
        .with { |req| JSON.parse(req.body)["tracking"] == { "loads" => true, "clicks" => true } }
    end
  end

  describe "#list" do
    it "returns a Collection of Email resources" do
      stub_api(:get, "/v2/emails?page=1&limit=10", body: {
        "data" => [
          { "object" => "email", "id" => "em_1", "status" => "delivered" },
          { "object" => "email", "id" => "em_2", "status" => "pending" },
        ],
        "next_page_url" => "/v2/emails?page=2&limit=10",
        "previous_page_url" => nil,
      })

      list = client.emails.list(page: 1, limit: 10)

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(2)
      expect(list.has_more?).to be true
      expect(list.data[0]).to be_a(Emailit::Email)
      expect(list.data[0].id).to eq("em_1")
      expect(list.data[1].id).to eq("em_2")
    end

    it "without params sends no query string" do
      stub_api(:get, "/v2/emails", body: {
        "data" => [], "next_page_url" => nil, "previous_page_url" => nil,
      })

      list = client.emails.list

      expect(list).to be_a(Emailit::Collection)
      expect(list.count).to eq(0)
      expect(list.has_more?).to be false
    end
  end

  describe "#get" do
    it "returns a typed Email resource" do
      stub_api(:get, "/v2/emails/em_abc123", body: {
        "object" => "email",
        "id" => "em_abc123",
        "type" => "outbound",
        "status" => "delivered",
        "from" => "sender@example.com",
        "to" => "recipient@example.com",
        "subject" => "Hello World",
      })

      email = client.emails.get("em_abc123")

      expect(email).to be_a(Emailit::Email)
      expect(email.id).to eq("em_abc123")
      expect(email.type).to eq("outbound")
      expect(email.status).to eq("delivered")
    end
  end

  describe "#get_raw" do
    it "returns Email with raw property" do
      stub_api(:get, "/v2/emails/em_abc123/raw", body: {
        "object" => "email",
        "id" => "em_abc123",
        "raw" => "From: sender@example.com\r\nTo: recipient@example.com\r\nSubject: Hello\r\n\r\nBody",
      })

      email = client.emails.get_raw("em_abc123")

      expect(email).to be_a(Emailit::Email)
      expect(email.raw).to include("From: sender@example.com")
    end
  end

  describe "#get_attachments" do
    it "returns a Collection" do
      stub_api(:get, "/v2/emails/em_abc123/attachments", body: {
        "object" => "list",
        "data" => [
          { "filename" => "doc.pdf", "content_type" => "application/pdf", "size" => 12345 },
        ],
      })

      attachments = client.emails.get_attachments("em_abc123")

      expect(attachments).to be_a(Emailit::Collection)
      expect(attachments.count).to eq(1)
      expect(attachments.data[0].filename).to eq("doc.pdf")
    end
  end

  describe "#get_body" do
    it "returns EmailitObject with text and html" do
      stub_api(:get, "/v2/emails/em_abc123/body", body: {
        "text" => "Plain text content",
        "html" => "<html><body><h1>Welcome!</h1></body></html>",
      })

      body = client.emails.get_body("em_abc123")

      expect(body).to be_a(Emailit::EmailitObject)
      expect(body.text).to eq("Plain text content")
      expect(body.html).to include("<h1>Welcome!</h1>")
    end
  end

  describe "#get_meta" do
    it "returns an Email resource with headers" do
      stub_api(:get, "/v2/emails/em_abc123/meta", body: {
        "object" => "email",
        "id" => "em_abc123",
        "headers" => { "From" => "sender@example.com", "Subject" => "Hello" },
        "attachments" => [{ "filename" => "doc.pdf", "size" => 12345 }],
      })

      meta = client.emails.get_meta("em_abc123")

      expect(meta).to be_a(Emailit::Email)
      expect(meta.headers["From"]).to eq("sender@example.com")
      expect(meta.attachments.length).to eq(1)
    end
  end

  describe "#update" do
    it "returns updated Email resource" do
      stub_api(:post, "/v2/emails/em_abc123", body: {
        "object" => "email",
        "id" => "em_abc123",
        "status" => "scheduled",
        "scheduled_at" => "2026-01-10T15:00:00.000Z",
        "message" => "Email schedule has been updated successfully",
      })

      email = client.emails.update("em_abc123", scheduled_at: "2026-01-10T15:00:00Z")

      expect(email).to be_a(Emailit::Email)
      expect(email.status).to eq("scheduled")
      expect(email.message).to include("updated successfully")
    end
  end

  describe "#cancel" do
    it "returns canceled Email resource" do
      stub_api(:post, "/v2/emails/em_abc123/cancel", body: {
        "object" => "email",
        "id" => "em_abc123",
        "status" => "canceled",
        "message" => "Email has been canceled successfully",
      })

      email = client.emails.cancel("em_abc123")

      expect(email).to be_a(Emailit::Email)
      expect(email.status).to eq("canceled")
    end
  end

  describe "#retry" do
    it "returns new Email resource with original_id" do
      stub_api(:post, "/v2/emails/em_abc123/retry", body: {
        "object" => "email",
        "id" => "em_new789",
        "original_id" => "em_abc123",
        "status" => "pending",
        "message" => "Email has been queued for retry",
      })

      email = client.emails.retry("em_abc123")

      expect(email).to be_a(Emailit::Email)
      expect(email.original_id).to eq("em_abc123")
      expect(email.id).to eq("em_new789")
      expect(email.status).to eq("pending")
    end
  end

  describe "resource features" do
    it "supports array access" do
      stub_api(:get, "/v2/emails/em_abc", body: { "object" => "email", "id" => "em_abc", "status" => "sent" })
      email = client.emails.get("em_abc")

      expect(email["id"]).to eq("em_abc")
      expect(email["status"]).to eq("sent")
      expect(email.key?("id")).to be true
      expect(email.key?("nonexistent")).to be false
    end

    it "supports to_hash" do
      stub_api(:get, "/v2/emails/em_abc", body: { "object" => "email", "id" => "em_abc", "status" => "sent" })
      email = client.emails.get("em_abc")

      expect(email.to_hash).to eq({ "object" => "email", "id" => "em_abc", "status" => "sent" })
    end

    it "is JSON serializable" do
      stub_api(:get, "/v2/emails/em_abc", body: { "object" => "email", "id" => "em_abc", "status" => "sent" })
      email = client.emails.get("em_abc")

      expect(email.to_json).to eq('{"object":"email","id":"em_abc","status":"sent"}')
    end

    it "exposes last_response" do
      stub_api(:get, "/v2/emails/em_abc", body: { "object" => "email", "id" => "em_abc" })
      email = client.emails.get("em_abc")

      expect(email.last_response).to be_a(Emailit::ApiResponse)
      expect(email.last_response.status_code).to eq(200)
    end

    it "collection is iterable" do
      stub_api(:get, "/v2/emails", body: {
        "data" => [
          { "object" => "email", "id" => "em_1" },
          { "object" => "email", "id" => "em_2" },
        ],
        "next_page_url" => nil,
        "previous_page_url" => nil,
      })

      list = client.emails.list
      ids = list.map(&:id)

      expect(ids).to eq(["em_1", "em_2"])
    end
  end

  describe "URL encoding" do
    it "url-encodes email id in path" do
      stub_api(:get, "/v2/emails/em_with+spaces", body: { "object" => "email", "id" => "em_with spaces" })
      client.emails.get("em_with spaces")

      expect(WebMock).to have_requested(:get, "#{API_BASE}/v2/emails/em_with+spaces")
    end
  end

  describe "error handling" do
    it "401 raises AuthenticationError" do
      stub_api(:get, "/v2/emails", status: 401, body: {
        "error" => "Unauthorized", "message" => "Invalid API key",
      })

      expect { client.emails.list }.to raise_error(Emailit::AuthenticationError, "Unauthorized: Invalid API key")
    end

    it "400 raises InvalidRequestError" do
      stub_api(:post, "/v2/emails", status: 400, body: {
        "error" => "Validation failed", "message" => "Missing required field: from",
      })

      expect { client.emails.send(to: ["user@example.com"]) }.to raise_error(
        Emailit::InvalidRequestError, "Validation failed: Missing required field: from"
      )
    end

    it "404 raises InvalidRequestError" do
      stub_api(:get, "/v2/emails/em_fake", status: 404, body: {
        "error" => "Email not found", "message" => "Email with ID 'em_fake' not found",
      })

      expect { client.emails.get("em_fake") }.to raise_error(Emailit::InvalidRequestError, /Email not found/)
    end

    it "422 raises UnprocessableEntityError" do
      stub_api(:post, "/v2/emails/em_sent/cancel", status: 422, body: {
        "error" => "Cannot cancel email", "message" => "Current status: 'sent'",
      })

      expect { client.emails.cancel("em_sent") }.to raise_error(Emailit::UnprocessableEntityError, /Cannot cancel email/)
    end

    it "429 raises RateLimitError" do
      stub_api(:post, "/v2/emails", status: 429, body: {
        "error" => "Rate limit exceeded", "message" => "Too many requests",
      })

      expect { client.emails.send(from: "a@b.com", to: "c@d.com", subject: "Hi", html: "Hi") }.to raise_error(
        Emailit::RateLimitError, "Rate limit exceeded: Too many requests"
      )
    end

    it "error exception carries full response data" do
      error_body = { "error" => "Email not found", "message" => "Not found in workspace" }
      stub_api(:get, "/v2/emails/em_nonexistent", status: 404, body: error_body)

      begin
        client.emails.get("em_nonexistent")
        raise "Expected exception"
      rescue Emailit::InvalidRequestError => e
        expect(e.http_status).to eq(404)
        expect(e.json_body).to eq(error_body)
        expect(e.http_body).to eq(JSON.generate(error_body))
      end
    end

    it "nested error format is extracted" do
      stub_api(:post, "/v2/emails", status: 400, body: {
        "error" => { "type" => "validation_error", "message" => "The recipient email address is invalid", "param" => "to" },
      })

      expect {
        client.emails.send(from: "a@b.com", to: "invalid", subject: "Hi", html: "Hi")
      }.to raise_error(Emailit::InvalidRequestError, "The recipient email address is invalid")
    end

    it "non-json error body uses fallback message" do
      stub_api_raw(:get, "/v2/emails", status: 502, body: "Bad Gateway")

      begin
        client.emails.list
        raise "Expected exception"
      rescue Emailit::ApiError => e
        expect(e.message).to eq("API request failed with status 502")
        expect(e.http_body).to eq("Bad Gateway")
      end
    end

    it "connection failure raises ConnectionError" do
      stub_request(:get, "#{API_BASE}/v2/emails").to_raise(Errno::ECONNREFUSED)

      expect { client.emails.list }.to raise_error(Emailit::ConnectionError, /Could not connect to the Emailit API/)
    end
  end
end
