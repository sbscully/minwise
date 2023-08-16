# frozen_string_literal: true

require "digest"

module Minwise
  class Preprocess
    def self.call(data, options)
      new(data, options).call
    end

    def initialize(data, options)
      @data = data
      @options = options
    end

    def call
      output = @data
      output = shingleize(output.to_str) if output.respond_to?(:to_str)
      output = tokenize(output) unless output.all? { |i| i.is_a?(Integer) }

      output
    end

    private

    def shingleize(string)
      0.upto(string.length - @options[:shingle_size] - 1).map do |i|
        string[i..i + @options[:shingle_size]]
      end
    end

    def tokenize(input)
      input.map do |element|
        Digest::MD5.hexdigest(element.to_str).to_i(16) % ((2**32) - 1)
      end
    end
  end
end
