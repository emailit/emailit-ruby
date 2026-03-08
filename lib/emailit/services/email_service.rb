# frozen_string_literal: true

module Emailit
  module Services
    class EmailService < BaseService
      def send(params)
        request(:post, "/v2/emails", params)
      end

      def list(params = {})
        request_collection(:get, "/v2/emails", params.empty? ? nil : params)
      end

      def get(id)
        request(:get, build_path("/v2/emails/%s", id))
      end

      def get_raw(id)
        request(:get, build_path("/v2/emails/%s/raw", id))
      end

      def get_attachments(id)
        request_collection(:get, build_path("/v2/emails/%s/attachments", id))
      end

      def get_body(id)
        request(:get, build_path("/v2/emails/%s/body", id))
      end

      def get_meta(id)
        request(:get, build_path("/v2/emails/%s/meta", id))
      end

      def update(id, params)
        request(:post, build_path("/v2/emails/%s", id), params)
      end

      def cancel(id)
        request(:post, build_path("/v2/emails/%s/cancel", id))
      end

      def retry(id)
        request(:post, build_path("/v2/emails/%s/retry", id))
      end
    end
  end
end
