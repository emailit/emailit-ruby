# frozen_string_literal: true

module Emailit
  module Services
    class SuppressionService < BaseService
      def create(params)
        request(:post, "/v2/suppressions", params)
      end

      def get(id)
        request(:get, build_path("/v2/suppressions/%s", id))
      end

      def update(id, params)
        request(:post, build_path("/v2/suppressions/%s", id), params)
      end

      def list(params = {})
        request_collection(:get, "/v2/suppressions", params.empty? ? nil : params)
      end

      def delete(id)
        request(:delete, build_path("/v2/suppressions/%s", id))
      end
    end
  end
end
