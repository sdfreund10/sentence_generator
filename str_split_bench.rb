require 'benchmark'

str = (1..10_000).map { ('a'..'z').to_a.sample(rand(4) + 3).join }.join(" ")
puts(
Benchmark.measure do
  100.times { str.split }
end
)

puts(
Benchmark.measure do
  100.times { str.split(' ') }
end
)

puts(
Benchmark.measure do
  100.times { str.split(/\s/) }
end
) 
puts(
Benchmark.measure do
  100.times do
  curr_word = ''
  words = []
  str.each_char do |c|
    if c == ' '
      words << curr_word
      curr_word = ''
    else
      curr_word << c
    end
  end
end
end
)
