import time

# Generate canonical line: 40 "f<num>" fields
seed = 12345
def ri(m):
    global seed
    seed = (seed * 16807) % 2147483647
    return seed % m

fields = []
for j in range(40):
    field_num = ri(1000) + 100
    fields.append("f" + str(field_num))
line = ",".join(fields)

R = 10000
sum_plen = 0
sum_idx = 0
sum_sub = 0

start = time.time() * 1000
for _ in range(R):
    parts = line.split(",")
    for p in parts:
        sum_plen += len(parts)
        sum_idx += p.index("f")
        if len(p) >= 4:
            sub = p[1:3]
            sum_sub += len(sub)

# Modulo only at final
m_plen = sum_plen % 1000003
m_idx = sum_idx % 1000003
m_sub = sum_sub % 1000003
acc = (m_plen + m_idx + m_sub) % 1000003

end = time.time() * 1000
print(f"Result: {acc}")
print(f"Time: {int(end - start)}ms")
