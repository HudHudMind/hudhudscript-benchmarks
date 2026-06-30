import time

size = 300
m = []
t = []
for i in range(size):
    row_m = []
    row_t = []
    for j in range(size):
        row_m.append(i + j)
        row_t.append(0)
    m.append(row_m)
    t.append(row_t)

start = time.time() * 1000
for i in range(size):
    for j in range(size):
        t[j][i] = m[i][j]
end = time.time() * 1000
print(f"T[0][0]: {t[0][0]}")
print(f"T[299][299]: {t[299][299]}")
print(f"Time: {end - start:.0f}ms")

