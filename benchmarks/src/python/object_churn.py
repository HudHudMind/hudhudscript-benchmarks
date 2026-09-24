import time

N = 500000
acc = 0
start = time.time() * 1000
for i in range(N):
    p = {"x": i, "y": i * 2, "z": 0}
    p["z"] = p["x"] + p["y"]
    acc = (acc + p["z"]) % 1000003
end = time.time() * 1000

print(f"Result: {acc}")
print(f"Time: {int(end - start)}ms")
