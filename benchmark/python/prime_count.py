import time
start = time.time() * 1000
count = 0
for n in range(2, 100001):
    is_p = True
    if n < 2: is_p = False
    elif n == 2: is_p = True
    elif n % 2 == 0: is_p = False
    else:
        i = 3
        while i * i <= n:
            if n % i == 0:
                is_p = False
                break
            i += 2
    if is_p:
        count += 1
end = time.time() * 1000
print(f"Primes: {count}")
print(f"Time: {end - start:.0f}ms")

