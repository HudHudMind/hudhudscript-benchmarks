import time

def power(base, exp):
    result = 1
    for i in range(exp):
        result = result * base
    return result

sum = 0
start = time.time() * 1000
for i in range(10000):
    sum = sum + power(2, 1000)
end = time.time() * 1000
print(f"Sum: {sum}")
print(f"Time: {end - start:.0f}ms")
