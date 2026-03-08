# frozen_string_literal: true

module Emailit
  class Collection < EmailitObject
    include Enumerable

    def data
      @values["data"] || []
    end

    def each(&block)
      data.each(&block)
    end

    def count
      data.length
    end
    alias size count
    alias length count

    def has_more?
      !@values["next_page_url"].nil?
    end
  end
end
