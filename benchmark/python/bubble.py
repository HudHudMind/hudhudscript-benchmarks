import time

n = 500
arr = []
for i in range(n, 0, -1):
    arr.append(i)
start = time.time() * 1000
for k in range(n):
    for j in range(n - 1):
        if arr[j] > arr[j + 1]:
            temp = arr[j]
            arr[j] = arr[j + 1]
            arr[j + 1] = temp
end = time.time() * 1000
print(f"First: {arr[0]}")
print(f"Last: {arr[n - 1]}")
print(f"Time: {end - start:.0f}ms")

