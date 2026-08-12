import time

seed = 42
def rng():
    global seed
    seed = (seed * 1103515245 + 12345) % 2147483648
    return ((seed - (seed % 65536)) // 65536) % 4

chars = "ACGT"
text_chars = []
for _ in range(500000):
    text_chars.append(chars[rng()])
text = "".join(text_chars)

def get_seed():
    global seed
    return seed

patterns = []
for i in range(15):
    start_pos = (get_seed() * 16807) % 499000
    seed = (seed * 16807) % 2147483647
    plen = 5 + (seed % 11)
    pat = text[start_pos:start_pos + plen]
    patterns.append(pat)

for i in range(5):
    pat = "QQQQQ" + str((seed * 16807) % 10)
    seed = (seed * 16807) % 2147483647
    patterns.append(pat)

start = time.time() * 1000

total_matches = 0
for pat in patterns:
    m = len(pat)
    fail = [0] * m
    j = 0
    for i in range(1, m):
        while j > 0 and pat[i] != pat[j]:
            j = fail[j - 1]
        if pat[i] == pat[j]:
            j += 1
        fail[i] = j
    
    j = 0
    for i in range(len(text)):
        while j > 0 and text[i] != pat[j]:
            j = fail[j - 1]
        if text[i] == pat[j]:
            j += 1
        if j == m:
            total_matches += 1
            j = fail[j - 1]

end = time.time() * 1000
print(f"Result: {total_matches}")
print(f"Time: {int(end - start)}ms")
