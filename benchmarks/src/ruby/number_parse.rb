n = 200000
$seed = 12345
def ri(m)
  $seed = ($seed * 16807) % 2147483647
  $seed % m
end

strings = []
n.times do
  s = ""
  s = "-" if ri(2) == 0
  nd = 1 + ri(9)
  s << (1 + ri(9)).to_s
  (nd - 1).times { s << ri(10).to_s }
  strings << s
end

start = Time.now.to_f * 1000
total = 0
M = 1000003

strings.each do |s|
  neg = false
  idx = 0
  if s[0] == "-"
    neg = true
    idx = 1
  end
  val = 0
  while idx < s.length
    c = s[idx]
    d = case c
        when "0" then 0
        when "1" then 1
        when "2" then 2
        when "3" then 3
        when "4" then 4
        when "5" then 5
        when "6" then 6
        when "7" then 7
        when "8" then 8
        else 9
        end
    val = val * 10 + d
    idx += 1
  end
  val = -val if neg
  total += val
end

r = ((total % M) + M) % M
finish = Time.now.to_f * 1000
puts "Result: #{r}"
puts "Time: #{(finish - start).round}ms"
