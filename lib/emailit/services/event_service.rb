# frozen_string_literal: true

module Emailit
  module Services
    class EventService < BaseService
      def list(params = {})
        request_collection(:get, "/v2/events", params.empty? ? nil : params)
      end

      def get(id)
        request(:get, build_path("/v2/events/%s", id))
      end
    end
  end
end
