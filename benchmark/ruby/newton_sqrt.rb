def sqrt_newton(n)
    return 0 if n == 0
    x = n / 2.0
    for _ in 0...20
        x = (x + n / x) / 2.0
    end
    x
end

start = Time.now.to_f * 1000
s = 0.0
for i in 1..10000
    s += sqrt_newton(i)
end
finish = Time.now.to_f * 1000
puts "Sum: #{s}"
puts "Time: #{(finish - start).round}ms"

