def ack(m, n)
  return n + 1 if m == 0
  return ack(m - 1, 1) if n == 0
  ack(m - 1, ack(m, n - 1))
end

start = Time.now.to_f * 1000
result = ack(3, 6)
finish = Time.now.to_f * 1000
puts "Result: #{result}"
puts "Time: #{(finish - start).round}ms"

