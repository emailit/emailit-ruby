# frozen_string_literal: true

module Emailit
  module Services
    class ApiKeyService < BaseService
      def create(params)
        request(:post, "/v2/api-keys", params)
      end

      def get(id)
        request(:get, build_path("/v2/api-keys/%s", id))
      end

      def list(params = {})
        request_collection(:get, "/v2/api-keys", params.empty? ? nil : params)
      end

      def update(id, params)
        request(:post, build_path("/v2/api-keys/%s", id), params)
      end

      def delete(id)
        request(:delete, build_path("/v2/api-keys/%s", id))
      end
    end
  end
end
