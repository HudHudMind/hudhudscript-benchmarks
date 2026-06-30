import time
arr = list(range(1000, 0, -1))
start = time.time() * 1000
stack = [0, len(arr) - 1]
while stack:
    high = stack.pop()
    low = stack.pop()
    if low < high:
        pivot = arr[high]
        pi = low - 1
        for j in range(low, high):
            if arr[j] <= pivot:
                pi += 1
                arr[pi], arr[j] = arr[j], arr[pi]
        pi += 1
        arr[pi], arr[high] = arr[high], arr[pi]
        if pi - 1 > low:
            stack.append(low)
            stack.append(pi - 1)
        if pi + 1 < high:
            stack.append(pi + 1)
            stack.append(high)
end = time.time() * 1000
print(f"First: {arr[0]}")
print(f"Last: {arr[-1]}")
print(f"Time: {end - start:.0f}ms")

