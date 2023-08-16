# frozen_string_literal: true

def read_test_data(filename)
  path = File.expand_path("../data/#{filename}", File.dirname(__FILE__))
  File.read(path).lines.map { |line| line.chomp.split(" ", 2) }
end
