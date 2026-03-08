# frozen_string_literal: true

module Emailit
  class ApiResource < EmailitObject
    OBJECT_NAME = ""

    def self.class_url
      "/v2/#{self::OBJECT_NAME}s"
    end

    def self.resource_url(id)
      "#{class_url}/#{CGI.escape(id)}"
    end

    def instance_url
      id = self["id"]
      raise "Could not determine instance URL: #{self.class} has no 'id'." unless id

      self.class.resource_url(id)
    end
  end
end
