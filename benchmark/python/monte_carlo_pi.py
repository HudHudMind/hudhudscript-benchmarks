import time
inside = 0
total = 500000
seed = 12345
def next_random():
    global seed
    seed = (seed * 16807) % 2147483647
    return seed / 2147483647.0

start = time.time() * 1000
for i in range(total):
    x = next_random()
    y = next_random()
    if x * x + y * y <= 1.0:
        inside += 1
end = time.time() * 1000
pi = 4.0 * inside / total
print(f"Pi: {pi}")
print(f"Time: {end - start:.0f}ms")
