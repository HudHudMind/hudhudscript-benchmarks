N = 500000
acc = 0
start = Time.now.to_f * 1000
N.times do |i|
    p = { x: i, y: i * 2, z: 0 }
    p[:z] = p[:x] + p[:y]
    acc = (acc + p[:z]) % 1000003
end
finish = Time.now.to_f * 1000
puts "Result: #{acc}"
puts "Time: #{(finish - start).round}ms"
