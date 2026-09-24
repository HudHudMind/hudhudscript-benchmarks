def eval_A(i, j):
    return 1.0 / (((i + j) * (i + j + 1) / 2) + i + 1)

def eval_A_times_u(u, v, n):
    for i in range(n):
        v[i] = 0
        for j in range(n):
            v[i] += eval_A(i, j) * u[j]

def eval_At_times_u(u, v, n):
    for i in range(n):
        v[i] = 0
        for j in range(n):
            v[i] += eval_A(j, i) * u[j]

def eval_AtA_times_u(u, v, w, n):
    eval_A_times_u(u, w, n)
    eval_At_times_u(w, v, n)

def spectral_norm(n):
    u = [1.0] * n
    v = [0.0] * n
    w = [0.0] * n
    for _ in range(10):
        eval_AtA_times_u(u, v, w, n)
        eval_AtA_times_u(v, u, w, n)
    vBv = 0.0
    vv = 0.0
    for i in range(n):
        vBv += u[i] * v[i]
        vv += v[i] * v[i]
    return (vBv / vv) ** 0.5

import time
start = time.time()
res = spectral_norm(150)
end = time.time()
print(f"Result: {res:.9f}")
print(f"Time: {int((end - start)*1000)}ms")
