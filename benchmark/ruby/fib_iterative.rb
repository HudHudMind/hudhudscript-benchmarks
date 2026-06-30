start = Time.now.to_f * 1000
def fib(n)
    return n if n <= 1
    a = 0
    b = 1
    (2..n).each do |i|
        temp = a + b
        a = b
        b = temp
    end
    b
end
s = 0
10000.times do
    s = s + fib(1000)
end
finish = Time.now.to_f * 1000
puts "Sum: #{s}"
puts "Time: #{(finish - start).round}ms"

