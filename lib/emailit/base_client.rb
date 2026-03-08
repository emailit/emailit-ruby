# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module Emailit
  class BaseClient
    DEFAULT_API_BASE = "https://api.emailit.com"

    attr_reader :api_key, :api_base

    def initialize(config)
      config = { api_key: config } if config.is_a?(String)
      config = symbolize_keys(config)

      raise ArgumentError, "api_key is required" if config[:api_key].nil? || config[:api_key].empty?

      @api_key = config[:api_key]
      @api_base = (config[:api_base] || DEFAULT_API_BASE).chomp("/")
      @timeout = config[:timeout] || 30
      @open_timeout = config[:open_timeout] || 10
    end

    def request(method, path, params = nil)
      uri = build_uri(path, method == :get ? params : nil)
      req = build_request(method, uri, method == :get ? nil : params)

      begin
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.read_timeout = @timeout
        http.open_timeout = @open_timeout

        response = http.request(req)
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, SocketError, Net::OpenTimeout => e
        raise ConnectionError, "Could not connect to the Emailit API: #{e.message}"
      rescue IOError, Net::ReadTimeout => e
        raise ConnectionError, "Communication with Emailit API failed: #{e.message}"
      end

      status_code = response.code.to_i
      headers = {}
      response.each_header { |k, v| headers[k] = v }
      body = response.body || ""

      api_response = ApiResponse.new(status_code, headers, body)

      handle_error_response(api_response) if status_code >= 400

      api_response
    end

    private

    def build_uri(path, query_params = nil)
      uri = URI.parse("#{@api_base}#{path}")
      if query_params && !query_params.empty?
        uri.query = URI.encode_www_form(query_params)
      end
      uri
    end

    def build_request(method, uri, body_params)
      klass = case method
              when :get    then Net::HTTP::Get
              when :post   then Net::HTTP::Post
              when :patch  then Net::HTTP::Patch
              when :put    then Net::HTTP::Put
              when :delete then Net::HTTP::Delete
              else raise ArgumentError, "Unsupported HTTP method: #{method}"
              end

      req = klass.new(uri)
      req["Authorization"] = "Bearer #{@api_key}"
      req["Content-Type"] = "application/json"
      req["User-Agent"] = "emailit-ruby/#{VERSION}"
      req.body = JSON.generate(body_params) if body_params
      req
    end

    def handle_error_response(response)
      message = extract_error_message(response)
      raise ApiError.from_response(
        message,
        http_status: response.status_code,
        http_body: response.body,
        json_body: response.json,
        http_headers: response.headers
      )
    end

    def extract_error_message(response)
      json = response.json
      if json.is_a?(Hash)
        error = json["error"]
        if error.is_a?(String)
          msg = error
          msg += ": #{json["message"]}" if json["message"]
          return msg
        end

        if error.is_a?(Hash) && error["message"]
          return error["message"]
        end
      end

      "API request failed with status #{response.status_code}"
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end
  end
end
