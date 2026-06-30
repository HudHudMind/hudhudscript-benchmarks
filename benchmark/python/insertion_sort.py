import time
arr = list(range(1000, 0, -1))
start = time.time() * 1000
for j in range(1, len(arr)):
    key = arr[j]
    k = j - 1
    while k >= 0 and arr[k] > key:
        arr[k + 1] = arr[k]
        k -= 1
    arr[k + 1] = key
end = time.time() * 1000
print(f"First: {arr[0]}")
print(f"Last: {arr[-1]}")
print(f"Time: {end - start:.0f}ms")

