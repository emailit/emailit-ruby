# frozen_string_literal: true

require "openssl"

module Emailit
  class WebhookSignature
    HEADER_SIGNATURE = "x-emailit-signature"
    HEADER_TIMESTAMP = "x-emailit-timestamp"
    DEFAULT_TOLERANCE = 300

    def self.verify(raw_body, signature, timestamp, secret, tolerance: DEFAULT_TOLERANCE)
      if tolerance
        age = Time.now.to_i - timestamp.to_i
        if age > tolerance
          raise ApiError.new(
            "Webhook timestamp is too old. The request may be a replay attack.",
            http_status: 401
          )
        end
      end

      computed = compute_signature(raw_body, timestamp, secret)

      unless secure_compare(computed, signature)
        raise ApiError.new(
          "Webhook signature verification failed.",
          http_status: 401
        )
      end

      payload = begin
        JSON.parse(raw_body)
      rescue JSON::ParserError
        raise ApiError.new(
          "Invalid webhook payload: unable to decode JSON.",
          http_status: 400
        )
      end

      Events::WebhookEvent.construct_from(payload)
    end

    def self.compute_signature(raw_body, timestamp, secret)
      signed_payload = "#{timestamp}.#{raw_body}"
      OpenSSL::HMAC.hexdigest("SHA256", secret, signed_payload)
    end

    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      l = a.unpack("C*")
      r = b.unpack("C*")
      result = 0
      l.zip(r) { |x, y| result |= x ^ y }
      result.zero?
    end
    private_class_method :secure_compare
  end
end
