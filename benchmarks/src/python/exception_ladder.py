import time

def f3(i):
    if i % 7 == 0:
        raise Exception("boom")
    return i * 2

def f2(i):
    return f3(i)

def f1(i):
    return f2(i)

N = 200000
acc = 0
caught = 0
start = time.time() * 1000
for i in range(1, N + 1):
    try:
        acc = (acc + f1(i)) % 1000003
    except Exception:
        caught += 1
end = time.time() * 1000

print(f"Result: {acc}_{caught}")
print(f"Time: {int(end - start)}ms")
