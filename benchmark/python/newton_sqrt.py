import time

def sqrt_newton(n):
    if n == 0:
        return 0
    x = n / 2.0
    for _ in range(20):
        x = (x + n / x) / 2.0
    return x

start = time.time() * 1000
s = 0.0
for i in range(1, 10001):
    s += sqrt_newton(i)
end = time.time() * 1000
print(f"Sum: {s}")
print(f"Time: {end - start:.0f}ms")

