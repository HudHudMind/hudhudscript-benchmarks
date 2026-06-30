start = Time.now.to_f * 1000
def fib(n, memo)
    return n if n <= 1
    return memo[n] if memo[n] != 0
    memo[n] = fib(n - 1, memo) + fib(n - 2, memo)
end
s = 0
10000.times do
    memo = Array.new(501, 0)
    s += fib(500, memo)
end
finish = Time.now.to_f * 1000
puts "Sum: #{s}"
puts "Time: #{(finish - start).round}ms"

