limit = 10000
sieve = Array.new(limit + 1, true)
sieve[0] = sieve[1] = false
start = Time.now.to_f * 1000
(2..Math.sqrt(limit).to_i).each do |p|
  if sieve[p]
    (p*p..limit).step(p) { |m| sieve[m] = false }
  end
end
count = 0
sieve.each { |x| count += 1 if x }
finish = Time.now.to_f * 1000
puts "Primes up to 10000: #{count}"
puts "Time: #{(finish - start).round}ms"

