start = Time.now.to_f * 1000
def fact(n)
    return 1 if n <= 1
    n * fact(n - 1)
end
result = fact(150)
finish = Time.now.to_f * 1000
puts "fact(150) = #{result}"
puts "Time: #{(finish - start).round}ms"

