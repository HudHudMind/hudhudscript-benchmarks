import time

def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)

start = time.time() * 1000
result = fib(30)
end = time.time() * 1000
print(f"fib(30) = {result}")
print(f"Time: {end - start:.0f}ms")

