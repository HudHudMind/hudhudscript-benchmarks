coeffs = (1..1001).to_a
start = Time.now.to_f * 1000
def horner(coeffs, x)
    result = coeffs[-1]
    (coeffs.length - 2).downto(0) do |i|
        result = result * x + coeffs[i]
    end
    result
end
s = 0
100000.times { s += horner(coeffs, 1.5) }
finish = Time.now.to_f * 1000
puts "Result: #{s}"
puts "Time: #{(finish - start).round}ms"

