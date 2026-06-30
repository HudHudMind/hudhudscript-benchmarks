arr = []
for i in 0..9999
    arr.push(i)
end
sum = 0
start = Time.now.to_f * 1000
for i in 0..9999
    sum = sum + arr[i]
end
finish = Time.now.to_f * 1000
puts "Sum: #{sum}"
puts "Time: #{(finish - start).round}ms"
