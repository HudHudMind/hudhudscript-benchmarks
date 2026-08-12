start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

$seed = 42
def rand_val(max_val)
  $seed = ($seed * 3877 + 29573) % 139968
  max_val * $seed / 139968.0
end

alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

iub = [
  ['a', 0.27], ['c', 0.12], ['g', 0.12], ['t', 0.27],
  ['B', 0.02], ['D', 0.02], ['H', 0.02], ['K', 0.02],
  ['M', 0.02], ['N', 0.02], ['R', 0.02], ['S', 0.02],
  ['V', 0.02], ['W', 0.02], ['Y', 0.02]
]

cp = 0.0
iub.each do |x|
  cp += x[1]
  x[1] = cp
end

res = 0
n = 50000

total = n * 2
while total > 0
  chunk = [60, total].min
  res += chunk
  total -= chunk
end

total = n * 3
while total > 0
  chunk = [60, total].min
  for c in 1..chunk
    r = rand_val(1.0)
    for j in 0...iub.length
      if r < iub[j][1]
        res += 1
        break
      end
    end
  end
  total -= chunk
end

finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Result: #{res}"
puts "Time: #{((finish - start) * 1000).to_i}ms"
