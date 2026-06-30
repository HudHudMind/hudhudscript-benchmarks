def generate_dna(length)
  chars = "ACGT"
  seq = ""
  seed = 42
  length.times do
    seed = (seed * 1103515245 + 12345) & 0x7fffffff
    idx = (seed >> 16) % 4
    seq << chars[idx]
  end
  seq
end

def count_frequencies(dna, k)
  freqs = Hash.new(0)
  n = dna.length - k + 1
  (0...n).each do |i|
    sub = dna[i, k]
    freqs[sub] += 1
  end
  freqs.size
end

start_time = Time.now.to_f * 1000
dna = generate_dna(100000)
c1 = count_frequencies(dna, 1)
c2 = count_frequencies(dna, 2)
c3 = count_frequencies(dna, 3)

res = c1 + c2 + c3
end_time = Time.now.to_f * 1000

puts "Count: #{res}"
puts "Time: #{(end_time - start_time).to_i}ms"
