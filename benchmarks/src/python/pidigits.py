# Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
# Native Python int (unbounded). D=600. Golden: 2668_6766940513
import time

D = 600
GUARD = 5
SCALE = D + 10

def arctan_inv(x):
    res = 0
    term = 10**SCALE // x
    x2 = x * x
    sign = 1
    k = 0
    while True:
        divisor = 2 * k + 1
        t_k = term // divisor
        if t_k == 0:
            break
        if sign > 0:
            res += t_k
        else:
            res -= t_k
        sign = -sign
        term //= x2
        k += 1
    return res

start = time.time() * 1000

a5 = arctan_inv(5)
a239 = arctan_inv(239)
pi = 16 * a5 - 4 * a239

s = str(pi)
if len(s) < D + 10:
    s = s.zfill(D + 10)
s = s[:D]

ds = sum(int(c) for c in s)
lt = s[-10:]

end = time.time() * 1000
print(f"Result: {ds}_{lt}")
print(f"Time: {int(end - start)}ms")
