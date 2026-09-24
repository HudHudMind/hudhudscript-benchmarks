import time

N = 100000
seed = 12345
acc = 0
start = time.time() * 1000

head = None
for _ in range(N):
    seed = (seed * 16807) % 2147483647
    head = {"value": seed % 10000, "next": head}

prev = None
cur = head
for _ in range(N):
    nxt = cur["next"]
    cur["next"] = prev
    prev = cur
    cur = nxt

pos = 0
walk = prev
for _ in range(N):
    acc = (acc + walk["value"] * pos) % 1000003
    pos += 1
    walk = walk["next"]

end = time.time() * 1000
print(f"Result: {acc}")
print(f"Time: {int(end - start)}ms")
