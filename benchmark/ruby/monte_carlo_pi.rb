inside = 0
total = 500000
$seed = 12345
def next_random
    $seed = ($seed * 16807) % 2147483647
    return $seed / 2147483647.0
end

start = Time.now.to_f * 1000
total.times do
    x = next_random
    y = next_random
    inside += 1 if x * x + y * y <= 1.0
end
finish = Time.now.to_f * 1000
pi = 4.0 * inside / total
puts "Pi: #{pi}"
puts "Time: #{(finish - start).round}ms"
