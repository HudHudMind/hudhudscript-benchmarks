def power(base, exp)
    result = 1
    for i in 1..exp
        result = result * base
    end
    result
end

sum = 0
start = Time.now.to_f * 1000
for i in 1..10000
    sum = sum + power(2, 1000)
end
finish = Time.now.to_f * 1000
puts "Sum: #{sum}"
puts "Time: #{(finish - start).round}ms"
