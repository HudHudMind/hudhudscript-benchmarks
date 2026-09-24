# Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
# Native Ruby Integer (unbounded). D=600. Golden: 2668_6766940513

D = 600
GUARD = 5
SCALE = D + 10

def arctan_inv(x)
  res = 0
  term = 10**SCALE / x
  x2 = x * x
  sign = 1
  k = 0
  loop do
    divisor = 2 * k + 1
    t_k = term / divisor
    break if t_k == 0
    if sign > 0
      res += t_k
    else
      res -= t_k
    end
    sign = -sign
    term /= x2
    k += 1
  end
  res
end

start = (Time.now.to_f * 1000).to_i

a5 = arctan_inv(5)
a239 = arctan_inv(239)
pi = 16 * a5 - 4 * a239

s = pi.to_s
s = s.rjust(D + 10, '0') if s.length < D + 10
s = s[0, D]

ds = s.chars.sum(&:to_i)
lt = s[-10, 10]

finish = (Time.now.to_f * 1000).to_i
puts "Result: #{ds}_#{lt}"
puts "Time: #{finish - start}ms"
