# frozen_string_literal: true

module Emailit
  module Services
    class WebhookService < BaseService
      def create(params)
        request(:post, "/v2/webhooks", params)
      end

      def get(id)
        request(:get, build_path("/v2/webhooks/%s", id))
      end

      def update(id, params)
        request(:post, build_path("/v2/webhooks/%s", id), params)
      end

      def list(params = {})
        request_collection(:get, "/v2/webhooks", params.empty? ? nil : params)
      end

      def delete(id)
        request(:delete, build_path("/v2/webhooks/%s", id))
      end
    end
  end
end
