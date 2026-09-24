import time
def is_prime(n):
    if n < 2: return False
    if n == 2: return True
    if n % 2 == 0: return False
    i = 3
    while i * i <= n:
        if n % i == 0: return False
        i += 2
    return True
start = time.time() * 1000
count = 0
for n in range(2, 100001):
    if is_prime(n):
        count += 1
end = time.time() * 1000
print(f"Result: {count}")
print(f"Time: {end - start:.0f}ms")
