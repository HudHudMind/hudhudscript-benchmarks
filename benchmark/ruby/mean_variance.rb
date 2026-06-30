start = Time.now.to_f * 1000
arr = (1..1000000).to_a
s = 0
arr.each { |x| s += x }
mean = s.to_f / arr.length
sq_diff = 0
arr.each do |x|
    d = x - mean
    sq_diff += d * d
end
variance = sq_diff / arr.length
finish = Time.now.to_f * 1000
puts "Mean: #{mean}"
puts "Variance: #{variance}"
puts "Time: #{(finish - start).round}ms"

