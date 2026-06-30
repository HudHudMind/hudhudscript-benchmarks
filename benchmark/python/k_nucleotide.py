import time

def generate_dna(length):
    chars = "ACGT"
    seq = []
    # simple deterministic LCG for deterministic string
    seed = 42
    for i in range(length):
        seed = (seed * 1103515245 + 12345) & 0x7fffffff
        seq.append(chars[(seed >> 16) % 4])
    return "".join(seq)

def count_frequencies(dna, k):
    freqs = {}
    n = len(dna) - k + 1
    for i in range(n):
        sub = dna[i:i+k]
        freqs[sub] = freqs.get(sub, 0) + 1
    return freqs

start = time.time() * 1000
dna = generate_dna(100000)
freq1 = count_frequencies(dna, 1)
freq2 = count_frequencies(dna, 2)
freq3 = count_frequencies(dna, 3)

res = len(freq1) + len(freq2) + len(freq3)

end = time.time() * 1000

print(f"Count: {res}")
print(f"Time: {end - start:.0f}ms")
