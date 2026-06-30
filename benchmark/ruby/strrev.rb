start = Time.now.to_f * 1000
s = "a" * 50000
rev = ""
(s.length - 1).downto(0) do |j|
  rev += s[j]
end
finish = Time.now.to_f * 1000
puts "Len: #{rev.length}"
puts "Time: #{(finish - start).round}ms"

