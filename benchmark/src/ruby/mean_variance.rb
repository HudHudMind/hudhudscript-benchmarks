arr = (1..1000000).to_a
s = 0
start = Time.now.to_f * 1000
arr.each { |x| s += x }
mean = s.to_f / arr.length
sq_diff = 0
arr.each do |x|
    d = x - mean
    sq_diff += d * d
end
variance = sq_diff / arr.length
finish = Time.now.to_f * 1000
puts "Result: #{mean.round(1)}/#{variance.round(1)}"
puts "Time: #{(finish - start).round}ms"

