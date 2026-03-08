# frozen_string_literal: true

module Emailit
  module Services
    class EmailVerificationListService < BaseService
      def create(params)
        request(:post, "/v2/email-verification-lists", params)
      end

      def list(params = {})
        request_collection(:get, "/v2/email-verification-lists", params.empty? ? nil : params)
      end

      def get(id)
        request(:get, build_path("/v2/email-verification-lists/%s", id))
      end

      def results(id, params = {})
        request_collection(:get, build_path("/v2/email-verification-lists/%s/results", id), params.empty? ? nil : params)
      end

      def export(id)
        request_raw(:get, build_path("/v2/email-verification-lists/%s/export", id))
      end
    end
  end
end
