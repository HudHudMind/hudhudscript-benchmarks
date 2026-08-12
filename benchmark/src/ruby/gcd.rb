start = Time.now.to_f * 1000
def gcd(a, b)
    while b != 0
        temp = b
        b = a % b
        a = temp
    end
    a
end
result = 0
(1..10000).each do |i|
    result = gcd(i * 12345, i * 6789 + 1)
end
finish = Time.now.to_f * 1000
puts "Result: #{result}"
puts "Time: #{(finish - start).round}ms"

