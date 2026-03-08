# frozen_string_literal: true

module Emailit
  class Error < StandardError; end

  class ConnectionError < Error; end

  class ApiError < Error
    attr_reader :http_status, :http_body, :json_body, :http_headers

    def initialize(message = nil, http_status: 0, http_body: "", json_body: nil, http_headers: {})
      @http_status = http_status
      @http_body = http_body
      @json_body = json_body
      @http_headers = http_headers
      super(message)
    end

    def self.from_response(message, http_status:, http_body:, json_body:, http_headers:)
      klass = case http_status
              when 401 then AuthenticationError
              when 429 then RateLimitError
              when 422 then UnprocessableEntityError
              when 400, 404 then InvalidRequestError
              else self
              end

      klass.new(message, http_status: http_status, http_body: http_body, json_body: json_body, http_headers: http_headers)
    end
  end

  class AuthenticationError < ApiError; end
  class InvalidRequestError < ApiError; end
  class RateLimitError < ApiError; end
  class UnprocessableEntityError < ApiError; end
end
