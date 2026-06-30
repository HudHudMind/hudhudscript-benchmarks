start = Time.now.to_f * 1000
max_steps = 0
max_n = 0
(1..10000).each do |n|
  steps = 0
  current = n
  while current != 1
    if current % 2 == 0
      current = current / 2
    else
      current = current * 3 + 1
    end
    steps += 1
  end
  if steps > max_steps
    max_steps = steps
    max_n = n
  end
end
finish = Time.now.to_f * 1000
puts "Max steps: #{max_steps} at n=#{max_n}"
puts "Time: #{(finish - start).round}ms"

