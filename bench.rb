load './example/example.rb'
require 'benchmark'

puts(
  Benchmark.measure do
  SentenceGenerator::Example.new.setup!
  end
)

