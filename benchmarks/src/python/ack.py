import time

def ack(m, n):
    if m == 0:
        return n + 1
    if n == 0:
        return ack(m - 1, 1)
    return ack(m - 1, ack(m, n - 1))

start = time.time() * 1000
result = ack(3, 6)
end = time.time() * 1000
print(f"Result: {result}")
print(f"Time: {end - start:.0f}ms")

