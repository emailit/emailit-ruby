# frozen_string_literal: true

module Emailit
  module Services
    class EmailVerificationService < BaseService
      def verify(params)
        request(:post, "/v2/email-verifications", params)
      end
    end
  end
end
