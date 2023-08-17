# frozen_string_literal: true

module Minwise
  # The classic minhash algorithm.
  #
  # The minhash digests of two arrays will share approximately the same
  # proportion of elements as the underlying arrays. This is useful for finding
  # similar items in large datasets.
  #
  # The interface is similar to classes in the `Digest` module of the standard
  # library.
  #
  #   Minwise::Minhash.digest([1, 2, 3])
  #   # => [1005141192, 713750329, 346603495, ...]
  #
  # String inputs are first converted to an array of fixed width chunks of
  # characters called "shingles". For example `"Chunky"` with a shingle
  # size of 3 would become `["Chu", "hun", "unk", "nky"]`, then that array is
  # used to generate the minhash. The `shingle_size` option controls the chunk
  # width used.
  #
  #   Minwise::Minhash.digest("Chunky bacon", shingle_size: 3)
  #   # => [437974493, 147728091, 1185236492, ...]
  #
  # The size of the output `hash_size` and `seed` for generating the hash can
  # also be set in options. Larger minhashes will give more accurate estimates
  # of similarity between items, but are slower to generate and take more space.
  #
  #   Minwise::Minhash.digest("Chunky bacon", hash_size: 900, seed: 84)
  #   # => [355390344, 825885127, 262059926, ...]
  #
  # When comparing two minhashes all the options used to generate the minhashes
  # must be identical for the comparison to be meaningful.
  #
  # Detailed information on how the minhash algorithm works and how minhashes
  # can be used can be found in "Chapter 3: Finding Similar Items" of the book
  # "Mining of Massive Datasets", by Leskovec, Rajaraman, and Ulman, available
  # for free at http://www.mmds.org/.
  #
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
      @data = parse(data)
    end

    def update(element)
      @data << element
    end

    def digest
      raise ArgumentError, "input must not be empty" if @data.empty?

      self.class.__hash(@data, @options[:hash_size], @options[:seed])
    end

    private

    def parse(data)
      return [] if data.empty?

      if data.respond_to?(:to_a)
        data
      elsif data.respond_to?(:to_str)
        self.class.__tokenize(data.to_str, @options[:shingle_size])
      else
        raise ArgumentError, "input must be a string or array of integers"
      end
    end
  end
end
