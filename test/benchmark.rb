# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minwise"
require "benchmark"

require_relative "support/data_helper"

_, articles = read_test_data("articles_10000.train").transpose

Benchmark.benchmark do |benchmark|
  benchmark.report("Minwise::Minhash") do
    articles.each do |article|
      Minwise::Minhash.digest(article)
    end
  end
end
