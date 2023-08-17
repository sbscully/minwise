# frozen_string_literal: true

require_relative "minwise/version"
require_relative "minwise/minwise"
require_relative "minwise/minhash"

# A Ruby library for generating minwise hashes.
module Minwise
  class Error < StandardError; end

  class << self
    # Returns the Jaccard similarity of 2 arrays, a number between 0.0 and 1.0.
    #
    # The arrays are treated as sets, i.e. duplicate elements in an array are
    # only counted once.
    def similarity(set_one, set_two)
      set_one.intersection(set_two).length / set_one.union(set_two).length.to_f
    end
  end
end
