# frozen_string_literal: true

module Emailit
  module Services
    class SubscriberService < BaseService
      def create(audience_id, params)
        request(:post, build_path("/v2/audiences/%s/subscribers", audience_id), params)
      end

      def get(audience_id, subscriber_id)
        request(:get, build_path("/v2/audiences/%s/subscribers/%s", audience_id, subscriber_id))
      end

      def update(audience_id, subscriber_id, params)
        request(:post, build_path("/v2/audiences/%s/subscribers/%s", audience_id, subscriber_id), params)
      end

      def list(audience_id, params = {})
        request_collection(:get, build_path("/v2/audiences/%s/subscribers", audience_id), params.empty? ? nil : params)
      end

      def delete(audience_id, subscriber_id)
        request(:delete, build_path("/v2/audiences/%s/subscribers/%s", audience_id, subscriber_id))
      end
    end
  end
end
