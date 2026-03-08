# Emailit Ruby

[![Tests](https://img.shields.io/github/actions/workflow/status/emailit/emailit-ruby/tests.yml?label=tests&style=for-the-badge&labelColor=111827)](https://github.com/emailit/emailit-ruby/actions)
[![Gem Version](https://img.shields.io/gem/v/emailit?style=for-the-badge&labelColor=111827)](https://rubygems.org/gems/emailit)
[![License](https://img.shields.io/github/license/emailit/emailit-ruby?style=for-the-badge&labelColor=111827)](https://github.com/emailit/emailit-ruby/blob/main/LICENSE)

The official Ruby and Rails SDK for the [Emailit](https://emailit.com) Email API.

## Requirements

- Ruby 3.0+
- No external dependencies (uses `net/http` from stdlib)

## Installation

```bash
gem install emailit
```

Or add to your Gemfile:

```ruby
gem "emailit"
```

## Getting Started

```ruby
require "emailit"

client = Emailit::EmailitClient.new("your_api_key")

email = client.emails.send(
  from: "hello@yourdomain.com",
  to: ["user@example.com"],
  subject: "Hello from Emailit",
  html: "<h1>Welcome!</h1><p>Thanks for signing up.</p>"
)

puts email.id     # em_abc123...
puts email.status # pending
```

All service methods return typed resource objects (`Email`, `Domain`, `Contact`, etc.) with direct property access -- just like the Stripe SDK.

## Available Services

| Service | Method | Description |
|---------|--------|-------------|
| Emails | `client.emails` | Send, list, get, cancel, retry emails |
| Domains | `client.domains` | Create, verify, list, manage sending domains |
| API Keys | `client.api_keys` | Create, list, manage API keys |
| Audiences | `client.audiences` | Create, list, manage audiences |
| Subscribers | `client.subscribers` | Add, list, manage subscribers in audiences |
| Templates | `client.templates` | Create, list, publish email templates |
| Suppressions | `client.suppressions` | Create, list, manage suppressed addresses |
| Email Verifications | `client.email_verifications` | Verify email addresses |
| Email Verification Lists | `client.email_verification_lists` | Create, list, get results, export |
| Webhooks | `client.webhooks` | Create, list, manage webhooks |
| Contacts | `client.contacts` | Create, list, manage contacts |
| Events | `client.events` | List and retrieve events |

## Usage

### Emails

#### Send an email

```ruby
email = client.emails.send(
  from: "hello@yourdomain.com",
  to: ["user@example.com"],
  subject: "Hello from Emailit",
  html: "<h1>Welcome!</h1>"
)

puts email.id
puts email.status
```

#### Send with a template

```ruby
email = client.emails.send(
  from: "hello@yourdomain.com",
  to: "user@example.com",
  template: "welcome_email",
  variables: {
    name: "John Doe",
    company: "Acme Inc"
  }
)
```

#### Send with attachments

```ruby
email = client.emails.send(
  from: "invoices@yourdomain.com",
  to: "customer@example.com",
  subject: "Your Invoice #12345",
  html: "<p>Please find your invoice attached.</p>",
  attachments: [
    {
      filename: "invoice.pdf",
      content: Base64.strict_encode64(File.read("invoice.pdf")),
      content_type: "application/pdf"
    }
  ]
)
```

#### Schedule an email

```ruby
email = client.emails.send(
  from: "reminders@yourdomain.com",
  to: "user@example.com",
  subject: "Appointment Reminder",
  html: "<p>Your appointment is tomorrow at 2 PM.</p>",
  scheduled_at: "2026-01-10T09:00:00Z"
)

puts email.status       # scheduled
puts email.scheduled_at # 2026-01-10T09:00:00Z
```

#### List emails

```ruby
emails = client.emails.list(page: 1, limit: 10)

emails.each do |email|
  puts "#{email.id} — #{email.status}"
end

if emails.has_more?
  # fetch next page
end
```

#### Cancel / Retry

```ruby
client.emails.cancel("em_abc123")
client.emails.retry("em_abc123")
```

---

### Domains

```ruby
# Create a domain
domain = client.domains.create(
  name: "example.com",
  track_loads: true,
  track_clicks: true
)
puts domain.id

# Verify DNS
domain = client.domains.verify("sd_123")

# List all domains
domains = client.domains.list

# Get a domain
domain = client.domains.get("sd_123")

# Update a domain
domain = client.domains.update("sd_123", track_clicks: false)

# Delete a domain
client.domains.delete("sd_123")
```

---

### API Keys

```ruby
# Create an API key
key = client.api_keys.create(
  name: "Production Key",
  scope: "full"
)
puts key.key # only available on create

# List all API keys
keys = client.api_keys.list

# Get an API key
key = client.api_keys.get("ak_123")

# Update an API key
client.api_keys.update("ak_123", name: "Renamed Key")

# Delete an API key
client.api_keys.delete("ak_123")
```

---

### Audiences

```ruby
# Create an audience
audience = client.audiences.create(name: "Newsletter")
puts audience.id
puts audience.token

# List audiences
audiences = client.audiences.list

# Get an audience
audience = client.audiences.get("aud_123")

# Update an audience
client.audiences.update("aud_123", name: "Updated Newsletter")

# Delete an audience
client.audiences.delete("aud_123")
```

---

### Subscribers

Subscribers belong to an audience, so the audience ID is always the first argument.

```ruby
# Add a subscriber
subscriber = client.subscribers.create("aud_123",
  email: "user@example.com",
  first_name: "John",
  last_name: "Doe"
)

# List subscribers in an audience
subscribers = client.subscribers.list("aud_123")

# Get a subscriber
subscriber = client.subscribers.get("aud_123", "sub_456")

# Update a subscriber
client.subscribers.update("aud_123", "sub_456", first_name: "Jane")

# Delete a subscriber
client.subscribers.delete("aud_123", "sub_456")
```

---

### Templates

```ruby
# Create a template
result = client.templates.create(
  name: "Welcome",
  subject: "Welcome!",
  html: "<h1>Hi {{name}}</h1>"
)

# List templates
templates = client.templates.list

# Get a template
template = client.templates.get("tem_123")

# Update a template
client.templates.update("tem_123", subject: "New Subject")

# Publish a template
client.templates.publish("tem_123")

# Delete a template
client.templates.delete("tem_123")
```

---

### Suppressions

```ruby
# Create a suppression
suppression = client.suppressions.create(
  email: "spam@example.com",
  type: "hard_bounce",
  reason: "Manual suppression"
)

# List suppressions
suppressions = client.suppressions.list

# Get a suppression
suppression = client.suppressions.get("sup_123")

# Update a suppression
client.suppressions.update("sup_123", reason: "Updated")

# Delete a suppression
client.suppressions.delete("sup_123")
```

---

### Email Verifications

```ruby
result = client.email_verifications.verify(email: "test@example.com")

puts result.status # valid
puts result.score  # 0.95
puts result.risk   # low
```

---

### Email Verification Lists

```ruby
# Create a verification list
list = client.email_verification_lists.create(
  name: "Marketing List Q1",
  emails: [
    "user1@example.com",
    "user2@example.com",
    "user3@example.com"
  ]
)
puts list.id     # evl_abc123...
puts list.status # pending

# List all verification lists
lists = client.email_verification_lists.list

# Get a verification list
list = client.email_verification_lists.get("evl_abc123")
puts list.stats["successful_verifications"]

# Get verification results
results = client.email_verification_lists.results("evl_abc123", page: 1, limit: 50)

results.each do |result|
  puts "#{result.email} — #{result.result}"
end

# Export results as XLSX
response = client.email_verification_lists.export("evl_abc123")
File.write("results.xlsx", response.body)
```

---

### Webhooks

```ruby
# Create a webhook
webhook = client.webhooks.create(
  name: "My Webhook",
  url: "https://example.com/hook",
  all_events: true,
  enabled: true
)
puts webhook.id

# List webhooks
webhooks = client.webhooks.list

# Get a webhook
webhook = client.webhooks.get("wh_123")

# Update a webhook
client.webhooks.update("wh_123", enabled: false)

# Delete a webhook
client.webhooks.delete("wh_123")
```

---

### Contacts

```ruby
# Create a contact
contact = client.contacts.create(
  email: "user@example.com",
  first_name: "John",
  last_name: "Doe"
)
puts contact.id

# List contacts
contacts = client.contacts.list

# Get a contact
contact = client.contacts.get("con_123")

# Update a contact
client.contacts.update("con_123", first_name: "Jane")

# Delete a contact
client.contacts.delete("con_123")
```

---

### Events

```ruby
# List events
events = client.events.list(type: "email.delivered")

events.each do |event|
  puts event.type
end

# Get an event
event = client.events.get("evt_123")
puts event.type
puts event.data["email_id"]
```

## Webhook Events

The SDK provides typed event classes for all Emailit webhook event types under the `Emailit::Events` namespace, plus a `WebhookSignature` class for verifying webhook request signatures.

### Verifying Webhook Signatures

```ruby
require "emailit"

raw_body = request.body.read
signature = request.headers["X-Emailit-Signature"]
timestamp = request.headers["X-Emailit-Timestamp"]
secret = "your_webhook_signing_secret"

begin
  event = Emailit::WebhookSignature.verify(raw_body, signature, timestamp, secret)

  # event is automatically typed based on the event type
  puts event.type     # e.g. "email.delivered"
  puts event.event_id # e.g. "evt_abc123"

  # Access the event data
  data = event.event_data

  case event
  when Emailit::Events::EmailDelivered
    handle_delivered(event)
  when Emailit::Events::EmailBounced
    handle_bounce(event)
  when Emailit::Events::ContactCreated
    handle_new_contact(event)
  else
    puts "Unhandled: #{event.type}"
  end
rescue Emailit::ApiError => e
  render plain: e.message, status: 401
end
```

You can disable replay protection by passing `tolerance: nil`, or set a custom tolerance in seconds:

```ruby
# Skip replay check
event = Emailit::WebhookSignature.verify(raw_body, signature, timestamp, secret, tolerance: nil)

# Custom 10-minute tolerance
event = Emailit::WebhookSignature.verify(raw_body, signature, timestamp, secret, tolerance: 600)
```

### Available Event Types

**Emails:** `email.accepted`, `email.scheduled`, `email.delivered`, `email.bounced`, `email.attempted`, `email.failed`, `email.rejected`, `email.suppressed`, `email.received`, `email.complained`, `email.clicked`, `email.loaded`

**Domains:** `domain.created`, `domain.updated`, `domain.deleted`

**Audiences:** `audience.created`, `audience.updated`, `audience.deleted`

**Subscribers:** `subscriber.created`, `subscriber.updated`, `subscriber.deleted`

**Contacts:** `contact.created`, `contact.updated`, `contact.deleted`

**Templates:** `template.created`, `template.updated`, `template.deleted`

**Suppressions:** `suppression.created`, `suppression.updated`, `suppression.deleted`

**Email Verifications:** `email_verification.created`, `email_verification.updated`, `email_verification.deleted`

**Email Verification Lists:** `email_verification_list.created`, `email_verification_list.updated`, `email_verification_list.deleted`

Each event type has a corresponding class under `Emailit::Events::` (e.g. `Emailit::Events::EmailDelivered`, `Emailit::Events::DomainCreated`). You can use `is_a?` checks or the `EVENT_TYPE` constant for routing:

```ruby
case event
when Emailit::Events::EmailDelivered
  handle_delivered(event)
when Emailit::Events::EmailBounced
  handle_bounce(event)
when Emailit::Events::ContactCreated
  handle_new_contact(event)
else
  puts "Unhandled: #{event.type}"
end
```

## Ruby on Rails (ActionMailer)

The SDK natively supports Ruby on Rails via ActionMailer. When Rails is detected, a `:emailit` delivery method is automatically registered.

### Configuration

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :emailit
config.action_mailer.emailit_settings = { api_key: ENV["EMAILIT_API_KEY"] }
```

### Usage

Once configured, all your existing mailers work with Emailit automatically:

```ruby
class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to our app!"
    )
  end
end

# Send it
UserMailer.welcome(user).deliver_now
UserMailer.welcome(user).deliver_later
```

The delivery method automatically converts `Mail::Message` objects to Emailit API params, including:

- `from`, `to`, `cc`, `bcc`, `reply_to`
- `subject`
- HTML and plain-text bodies (multipart supported)
- File attachments (base64-encoded)


```ruby
class NotificationMailer < ApplicationMailer
  def invoice(user, pdf_data)
    attachments["invoice.pdf"] = {
      mime_type: "application/pdf",
      content: pdf_data
    }

    mail(
      to: user.email,
      subject: "Your Invoice"
    )
  end
end
```

## Error Handling

The SDK raises typed exceptions for API errors:

```ruby
begin
  client.emails.send(
    from: "hello@yourdomain.com",
    to: "user@example.com",
    subject: "Hello",
    html: "<h1>Hi</h1>"
  )
rescue Emailit::AuthenticationError => e
  # Invalid API key (401)
rescue Emailit::InvalidRequestError => e
  # Bad request or not found (400, 404)
rescue Emailit::RateLimitError => e
  # Too many requests (429)
rescue Emailit::UnprocessableEntityError => e
  # Validation failed (422)
rescue Emailit::ConnectionError => e
  # Network error
rescue Emailit::ApiError => e
  # Any other API error
  puts e.http_status
  puts e.http_body
  puts e.json_body
end
```

## License

MIT -- see [LICENSE](LICENSE) for details.
