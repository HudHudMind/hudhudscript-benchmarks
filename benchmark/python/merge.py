import time
arr = list(range(1000, 0, -1))
start = time.time() * 1000
n = len(arr)
width = 1
while width < n:
    for left in range(0, n, 2 * width):
        mid = left + width - 1
        if mid < n - 1:
            right = left + 2 * width - 1
            if right >= n:
                right = n - 1
            n1 = mid - left + 1
            n2 = right - mid
            L = []
            R = []
            for k in range(n1):
                L.append(arr[left + k])
            for k in range(n2):
                R.append(arr[mid + 1 + k])
            i = j = 0
            m = left
            while i < n1 and j < n2:
                if L[i] <= R[j]:
                    arr[m] = L[i]
                    i += 1
                else:
                    arr[m] = R[j]
                    j += 1
                m += 1
            while i < n1:
                arr[m] = L[i]
                i += 1
                m += 1
            while j < n2:
                arr[m] = R[j]
                j += 1
                m += 1
    width *= 2
end = time.time() * 1000
print(f"First: {arr[0]}")
print(f"Last: {arr[-1]}")
print(f"Time: {end - start:.0f}ms")

