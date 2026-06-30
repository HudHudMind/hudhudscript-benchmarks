import time

a = []
b = []
for i in range(500000):
    a.append(i + 1)
    b.append(i + 2)
sum = 0
start = time.time() * 1000
for i in range(500000):
    sum = sum + a[i] * b[i]
end = time.time() * 1000
print(f"Dot: {sum}")
print(f"Time: {end - start:.0f}ms")
