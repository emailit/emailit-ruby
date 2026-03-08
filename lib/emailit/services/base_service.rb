# frozen_string_literal: true

require "cgi"

module Emailit
  module Services
    class BaseService
      def initialize(client)
        @client = client
      end

      private

      def request(method, path, params = nil)
        response = @client.request(method, path, params)
        obj = Util.convert_to_emailit_object(response.json)

        if obj
          obj.last_response = response
        else
          obj = EmailitObject.new
        end

        obj
      end

      def request_collection(method, path, params = nil)
        response = @client.request(method, path, params)
        obj = Util.convert_to_emailit_object(response.json)

        if obj.is_a?(Collection)
          obj.last_response = response
          return obj
        end

        collection = Collection.new(response.json || {})
        collection.last_response = response
        collection
      end

      def request_raw(method, path, params = nil)
        @client.request(method, path, params)
      end

      def build_path(pattern, *args)
        format(pattern, *args.map { |a| CGI.escape(a.to_s) })
      end
    end
  end
end
