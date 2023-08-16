# frozen_string_literal: true

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

    def self.batch(batch, options = {})
      batch.map do |data|
        digest(data, options)
      end
    end

    def initialize(data = [], options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @data = parse(data)
    end

    def update(element)
      @data << element
    end

    def digest
      self.class.__hash(@data, @options[:hash_size], @options[:seed])
    end

    private

    def parse(data)
      if data.respond_to?(:to_a)
        data
      elsif data.respond_to?(:to_str)
        self.class.__tokenize(data, @options[:shingle_size])
      else
        raise ArgumentError, "input must be a string or array of integers"
      end
    end
  end
end
