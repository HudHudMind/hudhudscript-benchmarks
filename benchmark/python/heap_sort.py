import time
arr = list(range(1000, 0, -1))
start = time.time() * 1000
def heapify(n, idx):
    largest = idx
    left = 2 * idx + 1
    right = 2 * idx + 2
    if left < n and arr[left] > arr[largest]: largest = left
    if right < n and arr[right] > arr[largest]: largest = right
    if largest != idx:
        arr[idx], arr[largest] = arr[largest], arr[idx]
        heapify(n, largest)
n = len(arr)
for j in range(n // 2 - 1, -1, -1): heapify(n, j)
for k in range(n - 1, 0, -1):
    arr[0], arr[k] = arr[k], arr[0]
    heapify(k, 0)
end = time.time() * 1000
print(f"First: {arr[0]}")
print(f"Last: {arr[-1]}")
print(f"Time: {end - start:.0f}ms")

