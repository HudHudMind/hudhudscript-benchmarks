import time
arr = [i + 1 for i in range(1000000)]
start = time.time() * 1000
s = 0
for x in arr:
    s += x
mean = s / len(arr)
sq_diff = 0
for x in arr:
    d = x - mean
    sq_diff += d * d
variance = sq_diff / len(arr)
end = time.time() * 1000
print(f"Mean: {mean}")
print(f"Variance: {variance}")
print(f"Time: {end - start:.0f}ms")

