# frozen_string_literal: true

require_relative "minwise/version"
require_relative "minwise/minwise"
require_relative "minwise/minhash"

module Minwise
  class Error < StandardError; end

  class << self
    def similarity(set_one, set_two)
      set_one.intersection(set_two).length / set_one.union(set_two).length.to_f
    end
  end
end
