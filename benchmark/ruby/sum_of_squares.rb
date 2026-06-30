sum = 0
start = Time.now.to_f * 1000
for i in 1..1000000
    sum = sum + i * i
end
finish = Time.now.to_f * 1000
puts "Sum: #{sum}"
puts "Time: #{(finish - start).round}ms"
