# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "rake/extensiontask"

desc "Compile all the extensions"
task build: :compile

Rake::ExtensionTask.new("minwise") do |ext|
  ext.lib_dir = "lib/minwise"
end

desc "Benchmark Minwise::Minhash.digest"
task benchmark: :build do
  ruby "./test/benchmark.rb"
end

task default: %i[clobber compile test rubocop]
