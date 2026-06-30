start = Time.now.to_f * 1000
total = 0
(1..100000).each do |n|
  x = n.to_f
  while x > 0.5
    if x % 2 >= 1
      total += 1
    end
    x = x / 2
  end
end
finish = Time.now.to_f * 1000
puts "Total: #{total}"
puts "Time: #{(finish - start).round}ms"

