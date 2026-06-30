def make_fasta(n):
    # Fasta output without printing, just returning checksum-like length
    # To avoid huge I/O, we build strings and return length.
    seed = [42]
    
    def rand(max_val):
        seed[0] = (seed[0] * 3877 + 29573) % 139968
        return max_val * seed[0] / 139968.0

    alu = (
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
    )

    iub = [
        ('a', 0.27), ('c', 0.12), ('g', 0.12), ('t', 0.27),
        ('B', 0.02), ('D', 0.02), ('H', 0.02), ('K', 0.02),
        ('M', 0.02), ('N', 0.02), ('R', 0.02), ('S', 0.02),
        ('V', 0.02), ('W', 0.02), ('Y', 0.02)
    ]
    
    # Cumulative probabilities
    p = 0.0
    for i in range(len(iub)):
        p += iub[i][1]
        iub[i] = (iub[i][0], p)

    res = 0
    
    # ONE
    idx = 0
    total = n * 2
    while total > 0:
        chunk = min(60, total)
        res += chunk
        total -= chunk
        idx = (idx + chunk) % len(alu)

    # TWO
    total = n * 3
    while total > 0:
        chunk = min(60, total)
        for _ in range(chunk):
            r = rand(1.0)
            for c, cp in iub:
                if r < cp:
                    res += 1
                    break
        total -= chunk

    return res

import time
start = time.time()
r = make_fasta(50000)
end = time.time()
print(f"Result: {r}")
print(f"Time: {int((end - start)*1000)}ms")
