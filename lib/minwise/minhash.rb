# frozen_string_literal: true

module Minwise
  class Minhash
    DEFAULT_OPTIONS = { hash_size: 128, seed: 3_141_592 }.freeze

    def self.digest(data, options = {})
      new(data, options).digest
    end

    def initialize(data = [], options = {})
      @data = Array(data)
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def update(element)
      @data << element
    end

    def digest
      self.class.__hash(@data, @options[:hash_size], @options[:seed])
    end
  end
end
