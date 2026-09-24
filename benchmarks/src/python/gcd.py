import time

def gcd(a, b):
    while b != 0:
        temp = b
        b = a % b
        a = temp
    return a

start = time.time() * 1000
result = 0
for i in range(1, 10001):
    result = gcd(i * 12345, i * 6789 + 1)
end = time.time() * 1000
print(f"Result: {result}")
print(f"Time: {end - start:.0f}ms")

