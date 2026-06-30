import time

n = 100000
arr = []
for i in range(1, n + 1):
    arr.append(i)
start = time.time() * 1000
cum = []
s = 0
for i in range(n):
    s = s + arr[i]
    cum.append(s)
end = time.time() * 1000
print(f"Last: {cum[n - 1]}")
print(f"Time: {end - start:.0f}ms")

