# frozen_string_literal: true

module Emailit
  module Services
    class ContactService < BaseService
      def create(params)
        request(:post, "/v2/contacts", params)
      end

      def get(id)
        request(:get, build_path("/v2/contacts/%s", id))
      end

      def update(id, params)
        request(:post, build_path("/v2/contacts/%s", id), params)
      end

      def list(params = {})
        request_collection(:get, "/v2/contacts", params.empty? ? nil : params)
      end

      def delete(id)
        request(:delete, build_path("/v2/contacts/%s", id))
      end
    end
  end
end
