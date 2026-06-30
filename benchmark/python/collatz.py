import time

start = time.time() * 1000
max_steps = 0
max_n = 0
for n in range(1, 10001):
    steps = 0
    current = n
    while current != 1:
        if current % 2 == 0:
            current = current // 2
        else:
            current = current * 3 + 1
        steps += 1
    if steps > max_steps:
        max_steps = steps
        max_n = n
end = time.time() * 1000
print(f"Max steps: {max_steps} at n={max_n}")
print(f"Time: {end - start:.0f}ms")

