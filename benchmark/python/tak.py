import time

def tak(x, y, z):
    if y < x:
        return tak(
            tak(x - 1, y, z),
            tak(y - 1, z, x),
            tak(z - 1, x, y)
        )
    return z

start = time.time() * 1000
res = 0
for i in range(10):
    res = tak(18, 12, 6)
end = time.time() * 1000

print(f"Result: {res}")
print(f"Time: {end - start:.0f}ms")
