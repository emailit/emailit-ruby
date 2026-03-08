# frozen_string_literal: true

module Emailit
  module Services
    class AudienceService < BaseService
      def create(params)
        request(:post, "/v2/audiences", params)
      end

      def get(id)
        request(:get, build_path("/v2/audiences/%s", id))
      end

      def update(id, params)
        request(:post, build_path("/v2/audiences/%s", id), params)
      end

      def list(params = {})
        request_collection(:get, "/v2/audiences", params.empty? ? nil : params)
      end

      def delete(id)
        request(:delete, build_path("/v2/audiences/%s", id))
      end
    end
  end
end
