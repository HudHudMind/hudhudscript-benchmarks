import time
limit = 10000
sieve = [True] * (limit + 1)
sieve[0] = sieve[1] = False
start = time.time() * 1000
for p in range(2, int(limit**0.5) + 1):
    if sieve[p]:
        for multiple in range(p * p, limit + 1, p):
            sieve[multiple] = False
count = 0
for x in sieve:
    if x:
        count += 1
end = time.time() * 1000
print(f"Primes up to 10000: {count}")
print(f"Time: {end - start:.0f}ms")

