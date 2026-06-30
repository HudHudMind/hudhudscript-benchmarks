import time
coeffs = [i + 1 for i in range(1001)]
def horner(coeffs, x):
    result = coeffs[-1]
    for i in range(len(coeffs) - 2, -1, -1):
        result = result * x + coeffs[i]
    return result
start = time.time() * 1000
s = 0
for _ in range(100000):
    s += horner(coeffs, 1.5)
end = time.time() * 1000
print(f"Sum: {s}")
print(f"Time: {end - start:.0f}ms")

