# frozen_string_literal: true

module Emailit
  module Services
    class DomainService < BaseService
      def create(params)
        request(:post, "/v2/domains", params)
      end

      def get(id)
        request(:get, build_path("/v2/domains/%s", id))
      end

      def verify(id)
        request(:post, build_path("/v2/domains/%s/verify", id))
      end

      def update(id, params)
        request(:patch, build_path("/v2/domains/%s", id), params)
      end

      def list(params = {})
        request_collection(:get, "/v2/domains", params.empty? ? nil : params)
      end

      def delete(id)
        request(:delete, build_path("/v2/domains/%s", id))
      end
    end
  end
end
