# frozen_string_literal: true

module Emailit
  class EmailitObject
    attr_reader :values
    attr_accessor :last_response

    def initialize(values = {})
      @values = values || {}
    end

    def [](key)
      @values[key.to_s]
    end

    def []=(key, value)
      @values[key.to_s] = value
    end

    def key?(key)
      @values.key?(key.to_s)
    end

    def to_hash
      @values
    end
    alias to_h to_hash

    def to_json(*args)
      JSON.generate(@values, *args)
    end

    def to_s
      JSON.pretty_generate(@values)
    end

    def respond_to_missing?(name, include_private = false)
      @values.key?(name.to_s) || super
    end

    def method_missing(name, *args)
      key = name.to_s
      if key.end_with?("=")
        @values[key.chomp("=")] = args.first
      elsif @values.key?(key)
        @values[key]
      else
        super
      end
    end

    def refresh_from(values)
      @values = values
      self
    end
  end
end
