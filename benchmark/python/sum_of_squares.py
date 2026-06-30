import time

sum = 0
start = time.time() * 1000
for i in range(1, 1000001):
    sum = sum + i * i
end = time.time() * 1000
print(f"Sum: {sum}")
print(f"Time: {end - start:.0f}ms")
