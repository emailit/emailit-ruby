# frozen_string_literal: true

module Emailit
  module Util
    OBJECT_TYPES = {}.freeze

    def self.register_object_type(name, klass)
      @object_types ||= {}
      @object_types[name] = klass
    end

    def self.object_types
      @object_types || {}
    end

    def self.convert_to_emailit_object(data)
      return nil if data.nil?

      if data.is_a?(Hash) && data["data"].is_a?(Array)
        data["data"] = data["data"].map { |item| convert_to_emailit_object(item) }
        collection = Collection.new(data)
        return collection
      end

      object_type = data["object"] if data.is_a?(Hash)
      mapping = object_types

      if object_type && mapping[object_type]
        mapping[object_type].new(data)
      else
        EmailitObject.new(data)
      end
    end
  end
end
