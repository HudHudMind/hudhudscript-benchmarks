s = ""
start = Time.now.to_f * 1000
for i in 1..50000
    s << "x"
end
finish = Time.now.to_f * 1000
puts "Result: #{s.length}"
puts "Time: #{(finish - start).round}ms"
