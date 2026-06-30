import time

arr = []
for i in range(10000):
    arr.append(i)
sum = 0
start = time.time() * 1000
for i in range(10000):
    sum = sum + arr[i]
end = time.time() * 1000
print(f"Sum: {sum}")
print(f"Time: {end - start:.0f}ms")
