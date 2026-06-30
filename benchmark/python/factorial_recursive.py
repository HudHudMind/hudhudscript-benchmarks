import time

def fact(n):
    if n <= 1:
        return 1
    return n * fact(n - 1)

start = time.time() * 1000
result = fact(150)
end = time.time() * 1000
print(f"fact(150) = {result}")
print(f"Time: {end - start:.0f}ms")

