import time

size = 150
a = []
b = []
c = []
for i in range(size):
    row_a = []
    row_b = []
    row_c = []
    for j in range(size):
        row_a.append(i + j)
        row_b.append(i - j)
        row_c.append(0)
    a.append(row_a)
    b.append(row_b)
    c.append(row_c)

start = time.time() * 1000
for i in range(size):
    for j in range(size):
        for k in range(size):
            c[i][j] = c[i][j] + a[i][k] * b[k][j]
end = time.time() * 1000
print(f"Result[0][0]: {c[0][0]}")
print(f"Result[149][149]: {c[149][149]}")
print(f"Time: {end - start:.0f}ms")

