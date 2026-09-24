n = 200000
$seed = 12345
def ri(m)
  $seed = ($seed * 16807) % 2147483647
  $seed % m
end

arr = []
n.times { arr << ri(1000000) }

start = Time.now.to_f * 1000

buckets = Array.new(10, 0)
output = Array.new(n)

6.times do |p|
  10.times { |i| buckets[i] = 0 }
  div = 10 ** p
  n.times do |i|
    d = (arr[i] / div) % 10
    buckets[d] += 1
  end
  (1..9).each { |i| buckets[i] += buckets[i - 1] }
  (n - 1).downto(0) do |i|
    d = (arr[i] / div) % 10
    buckets[d] -= 1
    output[buckets[d]] = arr[i]
  end
  arr, output = output, arr
end

c = 0
n.times { |i| c = (c + arr[i] * (i % 7)) % 1000003 }

finish = Time.now.to_f * 1000
puts "Result: #{arr[0]}/#{arr[n-1]}_#{c}"
puts "Time: #{(finish - start).round}ms"
