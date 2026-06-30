import time

arr = [i * 2 for i in range(100000)]
start = time.time() * 1000
found = 0
for j in range(10000):
    target = j * 20
    left = 0
    right = 99999
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            found += 1
            break
        if arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
end = time.time() * 1000
print(f"Found: {found}")
print(f"Time: {end - start:.0f}ms")

