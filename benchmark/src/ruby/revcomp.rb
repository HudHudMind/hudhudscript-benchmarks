COMP = {
  'A' => 'T', 'C' => 'G', 'G' => 'C', 'T' => 'A',
  'U' => 'A', 'M' => 'K', 'R' => 'Y', 'W' => 'W',
  'S' => 'S', 'Y' => 'R', 'K' => 'M', 'V' => 'B',
  'H' => 'D', 'D' => 'H', 'B' => 'V', 'N' => 'N',
  'a' => 'T', 'c' => 'G', 'g' => 'C', 't' => 'A',
  'u' => 'A', 'm' => 'K', 'r' => 'Y', 'w' => 'W',
  's' => 'S', 'y' => 'R', 'k' => 'M', 'v' => 'B',
  'h' => 'D', 'd' => 'H', 'b' => 'V', 'n' => 'N'
}

def reverse_complement(seq)
  count_A = 0
  (seq.length - 1).downto(0) do |i|
    c = seq[i]
    rep = COMP[c] || c
    count_A += 1 if rep == 'A'
  end
  count_A
end

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

seq = []
seed = 42
chars = ['A', 'C', 'G', 'T']
500000.times do
  seed = (seed * 1103515245 + 12345) & 0x7fffffff
  idx = (seed >> 16) % 4
  seq << chars[idx]
end
seq_str = seq.join

res = 0
10.times do
  res = reverse_complement(seq_str)
end

finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
puts "Result: #{res}"
puts "Time: #{((finish - start) * 1000).to_i}ms"
