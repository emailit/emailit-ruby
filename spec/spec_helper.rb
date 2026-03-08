# frozen_string_literal: true

require "emailit"
require "webmock/rspec"

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

API_BASE = "https://api.emailit.com"

def stub_api(method, path, status: 200, body: {}, request_body: nil)
  stub = stub_request(method, "#{API_BASE}#{path}")
  stub = stub.with(body: request_body) if request_body
  stub.to_return(
    status: status,
    headers: { "Content-Type" => "application/json" },
    body: JSON.generate(body)
  )
end

def stub_api_raw(method, path, status: 200, body: "", headers: {})
  stub_request(method, "#{API_BASE}#{path}").to_return(
    status: status,
    headers: headers,
    body: body
  )
end

def mock_client
  Emailit::EmailitClient.new("em_test_key")
end
