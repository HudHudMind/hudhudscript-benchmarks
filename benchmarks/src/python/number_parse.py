import time

n = 200000
seed = 12345
def ri(m):
    global seed
    seed = (seed * 16807) % 2147483647
    return seed % m

strings = []
for _ in range(n):
    s = ""
    if ri(2) == 0:
        s = "-"
    ndigits = 1 + ri(9)
    s += str(1 + ri(9))
    for _ in range(ndigits - 1):
        s += str(ri(10))
    strings.append(s)

start = time.time() * 1000

total = 0
for s in strings:
    neg = False
    idx = 0
    if s[0] == '-':
        neg = True
        idx = 1
    val = 0
    while idx < len(s):
        c = s[idx]
        if c == '0': d = 0
        elif c == '1': d = 1
        elif c == '2': d = 2
        elif c == '3': d = 3
        elif c == '4': d = 4
        elif c == '5': d = 5
        elif c == '6': d = 6
        elif c == '7': d = 7
        elif c == '8': d = 8
        else: d = 9
        val = val * 10 + d
        idx += 1
    if neg:
        val = -val
    total += val

M = 1000003
result = ((total % M) + M) % M

end = time.time() * 1000
print(f"Result: {result}")
print(f"Time: {int(end - start)}ms")
