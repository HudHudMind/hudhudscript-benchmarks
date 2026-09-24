base = (0...1000).to_a
R = 2000
acc = 0
start = Time.now.to_f * 1000
R.times do
    d = base.map { |x| x * 2 + 1 }
    f = d.select { |x| x % 3 != 0 }
    s = f.reduce(0) { |a, x| a + x }
    acc = (acc + s + f.length) % 1000003
end
finish = Time.now.to_f * 1000
puts "Result: #{acc}"
puts "Time: #{(finish - start).round}ms"
