import time

n = 200000
seed = 12345

def ri(m):
    global seed
    seed = (seed * 16807) % 2147483647
    return seed % m

arr = []
for _ in range(n):
    arr.append(ri(1000000))

start = time.time() * 1000

buckets = [0] * 10
output = [0] * n

for p in range(6):
    for i in range(10):
        buckets[i] = 0
    div = 10 ** p
    for i in range(n):
        d = (arr[i] // div) % 10
        buckets[d] += 1
    for i in range(1, 10):
        buckets[i] += buckets[i - 1]
    for i in range(n - 1, -1, -1):
        d = (arr[i] // div) % 10
        buckets[d] -= 1
        output[buckets[d]] = arr[i]
    arr, output = output, arr

c = 0
for i in range(n):
    c = (c + arr[i] * (i % 7)) % 1000003

end = time.time() * 1000

print(f"Result: {arr[0]}/{arr[n-1]}_{c}")
print(f"Time: {int(end - start)}ms")
