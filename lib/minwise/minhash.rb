# frozen_string_literal: true

require_relative "../preprocess"

module Minwise
  class Minhash
    DEFAULT_OPTIONS = {
      hash_size: 128,
      shingle_size: 5,
      seed: 3_141_592
    }.freeze

    def self.digest(data, options = {})
      new(data, options).digest
    end

    def initialize(data = [], options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @data = Preprocess.call(data, @options)
    end

    def update(element)
      @data << element
    end

    def digest
      self.class.__hash(@data, @options[:hash_size], @options[:seed])
    end
  end
end
