import time
from functools import reduce

base = list(range(1000))
R = 2000
acc = 0
start = time.time() * 1000
for _ in range(R):
    d = list(map(lambda x: x * 2 + 1, base))
    f = list(filter(lambda x: x % 3 != 0, d))
    s = reduce(lambda a, x: a + x, f, 0)
    acc = (acc + s + len(f)) % 1000003
end = time.time() * 1000

print(f"Result: {acc}")
print(f"Time: {int(end - start)}ms")
