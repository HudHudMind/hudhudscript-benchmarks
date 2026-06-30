def fib(n)
  return n if n < 2
  fib(n - 1) + fib(n - 2)
end

start = Time.now.to_f * 1000
result = fib(30)
finish = Time.now.to_f * 1000
puts "fib(30) = #{result}"
puts "Time: #{(finish - start).round}ms"

