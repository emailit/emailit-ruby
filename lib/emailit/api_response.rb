# frozen_string_literal: true

module Emailit
  class ApiResponse
    attr_reader :status_code, :headers, :body, :json

    def initialize(status_code, headers, body)
      @status_code = status_code
      @headers = headers
      @body = body
      @json = begin
        JSON.parse(body)
      rescue JSON::ParserError
        nil
      end
    end
  end
end
