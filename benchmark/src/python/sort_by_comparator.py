import time

N = 20000
arr = []
seed = 12345
for _ in range(N):
    seed = (seed * 16807) % 2147483647
    arr.append(seed % 1000000)

def quicksort(a, low, high, cmp):
    if low >= high: return
    stack = [low, high]
    while stack:
        h = stack.pop()
        l = stack.pop()
        if l >= h: continue
        pivot = a[(l + h) // 2]
        i2, j2 = l, h
        while i2 <= j2:
            while cmp(a[i2], pivot) < 0: i2 += 1
            while cmp(a[j2], pivot) > 0: j2 -= 1
            if i2 <= j2:
                a[i2], a[j2] = a[j2], a[i2]
                i2 += 1; j2 -= 1
        if l < j2: stack.append(l); stack.append(j2)
        if i2 < h: stack.append(i2); stack.append(h)

def asc(a, b): return a - b
def desc(a, b): return b - a

start = time.time() * 1000
copy1 = arr[:]
quicksort(copy1, 0, N - 1, asc)
copy2 = arr[:]
quicksort(copy2, 0, N - 1, desc)
c1 = sum(copy1[i] * (i % 7) for i in range(N)) % 1000003
c2 = sum(copy2[i] * (i % 7) for i in range(N)) % 1000003
end = time.time() * 1000
print(f"Result: {c1}_{c2}")
print(f"Time: {int(end - start)}ms")
