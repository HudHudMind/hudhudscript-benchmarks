def is_prime(n)
  return false if n < 2
  return true if n == 2
  return false if n % 2 == 0
  i = 3
  while i * i <= n
    return false if n % i == 0
    i += 2
  end
  true
end

count = 0
start = Time.now.to_f * 1000
(2..100000).each { |n| count += 1 if is_prime(n) }
finish = Time.now.to_f * 1000
puts "Result: #{count}"
puts "Time: #{(finish - start).round}ms"
