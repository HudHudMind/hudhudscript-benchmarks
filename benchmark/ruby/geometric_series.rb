start = Time.now.to_f * 1000
r = 0.999
s = 0.0
term = 1.0
1000000.times do
    s += term
    term *= r
end
finish = Time.now.to_f * 1000
puts "Sum: #{s}"
puts "Time: #{(finish - start).round}ms"

