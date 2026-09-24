import time

def make_counter(start):
    c = start
    def counter():
        nonlocal c
        c = c + 1
        return c
    return counter

N = 150000
acc = 0
start = time.time() * 1000
for i in range(N):
    ctr = make_counter(i % 1000)
    acc = (acc + ctr() + ctr() + ctr()) % 1000003
end = time.time() * 1000

print(f"Result: {acc}")
print(f"Time: {int(end - start)}ms")
