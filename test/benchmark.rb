# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minwise"
require "benchmark"

require_relative "support/data_helper"

_, articles = read_test_data("articles_1000.train").transpose

Benchmark.benchmark do |benchmark|
  benchmark.report("Minwise::Minhash") do
    Minwise::Minhash.batch(articles)
  end
end
