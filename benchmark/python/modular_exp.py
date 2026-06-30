import time
start = time.time() * 1000
def mod_exp(base, exp, mod):
    result = 1
    b = base % mod
    e = exp
    while e > 0:
        if e % 2 == 1:
            result = (result * b) % mod
        b = (b * b) % mod
        e = e // 2
    return result

s = 0
for _ in range(10000):
    s += mod_exp(3, 1000, 1000000007)
end = time.time() * 1000
print(f"Sum: {s}")
print(f"Time: {end - start:.0f}ms")

