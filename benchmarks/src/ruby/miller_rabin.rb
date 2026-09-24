$seed = 12345
def ri(m)
  $seed = ($seed * 16807) % 2147483647
  $seed % m
end

def pm(b, e, m)
  r = 1
  while e > 0
    r = (r * b) % m if e & 1 == 1
    e >>= 1
    b = (b * b) % m
  end
  r
end

def ip(n)
  return 0 if n < 2
  return 1 if n == 2
  return 0 if n % 2 == 0
  d = n - 1
  s = 0
  while d % 2 == 0
    d >>= 1
    s += 1
  end
  [2, 3, 5, 7].each do |a|
    next if a >= n
    x = pm(a, d, n)
    next if x == 1 || x == n - 1
    ok = 0
    (s - 1).times do
      x = (x * x) % n
      if x == n - 1
        ok = 1
        break
      end
    end
    return 0 if ok == 0
  end
  1
end

K = 2000
cnt = 0
start = Time.now.to_f * 1000
K.times do
  n = 1000000001 + 2 * ri(500000000)
  cnt += 1 if ip(n) == 1
end
finish = Time.now.to_f * 1000
puts "Result: #{cnt}"
puts "Time: #{(finish - start).round}ms"
