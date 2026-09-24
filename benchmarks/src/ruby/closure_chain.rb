def make_counter(start)
    c = start
    return lambda { c = c + 1; c }
end

N = 150000
acc = 0
start = Time.now.to_f * 1000
N.times do |i|
    ctr = make_counter(i % 1000)
    acc = (acc + ctr.call + ctr.call + ctr.call) % 1000003
end
finish = Time.now.to_f * 1000
puts "Result: #{acc}"
puts "Time: #{(finish - start).round}ms"
