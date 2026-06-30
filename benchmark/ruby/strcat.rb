s = ""
start = Time.now.to_f * 1000
for i in 1..50000
    s = s + "x"
end
finish = Time.now.to_f * 1000
puts "Length: #{s.length}"
puts "Time: #{(finish - start).round}ms"
