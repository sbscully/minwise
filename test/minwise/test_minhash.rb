# frozen_string_literal: true

require "test_helper"
require "digest"

class TestMinhash < Minitest::Test
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
    minhash_a = Minwise::Minhash.digest("The quick brown fox jumped over the lazy dog")
    minhash_b = Minwise::Minhash.digest("he quick brown fox jumped over the lazy dog")

    refute_equal(minhash_a, minhash_b)
    assert_in_delta(0.90, Minwise.similarity(minhash_a, minhash_b), 0.1)
  end

  def test_find_duplicates
    pathname = File.expand_path("../data/articles_1000.train", File.dirname(__FILE__))
    data = File.read(pathname).lines.to_h { |line| line.chomp.split(" ", 2) }

    pathname = File.expand_path("../data/articles_1000.truth", File.dirname(__FILE__))
    expected = File.read(pathname).lines.map { |line| line.chomp.split(" ", 2) }

    ids, texts = data.to_a.transpose
    minhashes = Minwise::Minhash.batch(texts)
    minhashes = ids.zip(minhashes)

    found = []
    minhashes.to_a.combination(2).map do |(id_one, minhash_one), (id_two, minhash_two)|
      found << [id_one, id_two] if Minwise.similarity(minhash_one, minhash_two) > 0.5
    end

    assert_equal(expected.sort, found.sort)
  end
end
