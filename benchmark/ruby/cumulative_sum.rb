n = 100000
arr = []
(1..n).each { |i| arr << i }
start = Time.now.to_f * 1000
cum = []
s = 0
n.times do |i|
    s = s + arr[i]
    cum << s
end
finish = Time.now.to_f * 1000
puts "Last: #{cum[n - 1]}"
puts "Time: #{(finish - start).round}ms"

