# frozen_string_literal: true

require "test_helper"

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

  def test_empty_input_throws_error
    assert_raises(ArgumentError) do
      Minwise::Minhash.digest("")
    end

    assert_raises(ArgumentError) do
      Minwise::Minhash.digest([])
    end
  end

  def test_hash_size_option
    assert_equal(100, Minwise::Minhash.digest("The quick brown fox", hash_size: 100).length)
  end

  def test_shingle_size_larger_than_string
    tokens = Minwise::Minhash.__tokenize("string", 10)

    assert_equal(1, tokens.length)
  end

  def test_similar_input_gives_similar_hashes
    minhash_a = Minwise::Minhash.digest("The quick brown fox jumped over the lazy dog")
    minhash_b = Minwise::Minhash.digest("he quick brown fox jumped over the lazy dog")

    refute_equal(minhash_a, minhash_b)
    assert_in_delta(0.90, Minwise.similarity(minhash_a, minhash_b), 0.1)
  end

  def test_dissimilar_input_gives_dissimilar_hashes
    minhash_a = Minwise::Minhash.digest("The quick brown fox jumped over the lazy dog")
    minhash_b = Minwise::Minhash.digest("The five boxing wizards jump quickly")

    refute_equal(minhash_a, minhash_b)
    assert_in_delta(0.1, Minwise.similarity(minhash_a, minhash_b), 0.1)
  end

  def test_find_duplicates
    articles = read_test_data("articles_100.train")
    expected = read_test_data("articles_100.truth")

    ids, texts = articles.transpose
    minhashes = ids.zip(texts.map { |text| Minwise::Minhash.digest(text) })

    duplicates = minhashes.combination(2).filter_map do |(id_one, minhash_one), (id_two, minhash_two)|
      [id_one, id_two] if Minwise.similarity(minhash_one, minhash_two) > 0.5
    end

    assert_equal(expected.sort, duplicates.sort)
  end
end
