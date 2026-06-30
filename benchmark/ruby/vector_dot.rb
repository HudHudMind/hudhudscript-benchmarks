a = []
b = []
for i in 1..500000
    a.push(i)
    b.push(i + 1)
end
sum = 0
start = Time.now.to_f * 1000
for i in 0..499999
    sum = sum + a[i] * b[i]
end
finish = Time.now.to_f * 1000
puts "Dot: #{sum}"
puts "Time: #{(finish - start).round}ms"
