import time

s = ""
start = time.time() * 1000
for i in range(50000):
    s = s + "x"
end = time.time() * 1000
print(f"Length: {len(s)}")
print(f"Time: {end - start:.0f}ms")
