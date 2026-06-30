import time

start = time.time() * 1000
total = 0
for n in range(1, 100001):
    x = n
    while x > 0:
        total += x & 1
        x >>= 1
end = time.time() * 1000
print(f"Total: {total}")
print(f"Time: {end - start:.0f}ms")

