# frozen_string_literal: true

require "test_helper"
require "digest"

class TestMinhash < Minitest::Test
  def tokenize(string, length = 5)
    0.upto(string.length - length - 1).map do |i|
      token = string[i..i + length]
      token = Digest::MD5.hexdigest(token)
      token.to_i(16) % ((2**32) - 1)
    end
  end

  def similarity(arr_one, arr_two)
    arr_one.intersection(arr_two).length / arr_one.union(arr_two).length.to_f
  end

  def test_hash_is_array_of_integers
    minhash = Minwise::Minhash.digest([1, 2, 3])

    assert_kind_of(Array, minhash)
    assert_kind_of(Integer, minhash[0])
  end

  def test_hash_is_consistent
    minhash_a = Minwise::Minhash.digest([1, 2, 3])
    minhash_b = Minwise::Minhash.digest([1, 2, 3])

    assert_equal(minhash_a, minhash_b)
  end

  def test_similar_input_gives_similar_hashes
    a = "The quick brown fox jumped over the lazy dog"
    b = "he quick brown fox jumped over the lazy dog"
    minhash_a = Minwise::Minhash.digest(tokenize(a))
    minhash_b = Minwise::Minhash.digest(tokenize(b))

    refute_equal(minhash_a, minhash_b)
    assert_in_delta(0.90, similarity(minhash_a, minhash_b), 0.1)
  end
end
