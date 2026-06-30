import time
start = time.time() * 1000
r = 0.999
s = 0.0
term = 1.0
for _ in range(1000000):
    s += term
    term *= r
end = time.time() * 1000
print(f"Sum: {s}")
print(f"Time: {end - start:.0f}ms")

