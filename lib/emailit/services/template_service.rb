# frozen_string_literal: true

module Emailit
  module Services
    class TemplateService < BaseService
      def create(params)
        request(:post, "/v2/templates", params)
      end

      def get(id)
        request(:get, build_path("/v2/templates/%s", id))
      end

      def update(id, params)
        request(:post, build_path("/v2/templates/%s", id), params)
      end

      def list(params = {})
        request_collection(:get, "/v2/templates", params.empty? ? nil : params)
      end

      def delete(id)
        request(:delete, build_path("/v2/templates/%s", id))
      end

      def publish(id)
        request(:post, build_path("/v2/templates/%s/publish", id))
      end
    end
  end
end
