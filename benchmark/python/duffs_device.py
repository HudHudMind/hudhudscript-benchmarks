import time

def duffs_device(count):
    a = [0] * count
    b = [1] * count
    # manual loop unrolling (chunk size 8)
    n = count // 8
    rem = count % 8
    
    i = 0
    # Remainder
    while rem > 0:
        a[i] = b[i]
        i += 1
        rem -= 1
        
    # Chunks of 8
    while n > 0:
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        a[i] = b[i]; i += 1
        n -= 1
    return a[-1]

start = time.time() * 1000
res = 0
for _ in range(100):
    res = duffs_device(100000)
end = time.time() * 1000

print(f"Result: {res}")
print(f"Time: {end - start:.0f}ms")
