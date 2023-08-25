# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minwise"
require "benchmark"

require_relative "support/data_helper"

puts "\n= Benchmark =\n"

filename = "articles_10000.train"
puts "Hash all articles in test/data/#{filename}\n\n"

_, articles = read_test_data(filename).transpose

Benchmark.benchmark do |benchmark|
  benchmark.report("Minwise::Minhash") do
    articles.each do |article|
      Minwise::Minhash.digest(article)
    end
  end
end
