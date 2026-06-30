def reverse_complement(seq):
    comp = {
        'A': 'T', 'C': 'G', 'G': 'C', 'T': 'A',
        'U': 'A', 'M': 'K', 'R': 'Y', 'W': 'W',
        'S': 'S', 'Y': 'R', 'K': 'M', 'V': 'B',
        'H': 'D', 'D': 'H', 'B': 'V', 'N': 'N',
        'a': 'T', 'c': 'G', 'g': 'C', 't': 'A',
        'u': 'A', 'm': 'K', 'r': 'Y', 'w': 'W',
        's': 'S', 'y': 'R', 'k': 'M', 'v': 'B',
        'h': 'D', 'd': 'H', 'b': 'V', 'n': 'N'
    }
    # We simulate a large input and process it
    # Just return the count of A's in the reverse complemented sequence
    count_A = 0
    for char in reversed(seq):
        if comp.get(char, char) == 'A':
            count_A += 1
    return count_A

import time
start = time.time()

# Generate deterministic pseudo-random sequence
seq = []
seed = 42
for _ in range(500000):
    seed = (seed * 1103515245 + 12345) & 0x7fffffff
    idx = (seed >> 16) % 4
    seq.append("ACGT"[idx])

seq_str = "".join(seq)
res = 0
for _ in range(10):
    res = reverse_complement(seq_str)
end = time.time()

print(f"Result: {res}")
print(f"Time: {int((end - start)*1000)}ms")
