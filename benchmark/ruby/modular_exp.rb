start = Time.now.to_f * 1000
def mod_exp(base, exp, mod)
    result = 1
    b = base % mod
    e = exp
    while e > 0
        if e % 2 == 1
            result = (result * b) % mod
        end
        b = (b * b) % mod
        e /= 2
    end
    result
end
s = 0
10000.times { s += mod_exp(3, 1000, 1000000007) }
finish = Time.now.to_f * 1000
puts "Sum: #{s}"
puts "Time: #{(finish - start).round}ms"

