import time
s = "a" * 50000
start = time.time() * 1000
rev = ""
for j in range(len(s) - 1, -1, -1):
    rev += s[j]
end = time.time() * 1000
print(f"Len: {len(rev)}")
print(f"Time: {end - start:.0f}ms")

