start = Time.now.to_f * 1000
result = 1
(2..10000).each { |i| result *= i }
finish = Time.now.to_f * 1000
puts "Result: #{result}"
puts "Time: #{(finish - start).round}ms"

