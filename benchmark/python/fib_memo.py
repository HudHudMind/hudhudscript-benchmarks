import time
def fib(n, memo):
    if n <= 1: return n
    if memo[n]: return memo[n]
    memo[n] = fib(n - 1, memo) + fib(n - 2, memo)
    return memo[n]
start = time.time() * 1000
s = 0
for _ in range(10000):
    memo = [0] * 501
    s += fib(500, memo)
end = time.time() * 1000
print(f"Sum: {s}")
print(f"Time: {end - start:.0f}ms")

