import time
weights = [(i * 7 + 3) % 20 + 1 for i in range(50)]
values = [(i * 13 + 5) % 50 + 10 for i in range(50)]
capacity = 100
start = time.time() * 1000
n = len(weights)
dp = [[0] * (capacity + 1) for _ in range(n + 1)]
for i in range(1, n + 1):
    for w in range(capacity + 1):
        if weights[i - 1] <= w:
            incl = values[i - 1] + dp[i - 1][w - weights[i - 1]]
            dp[i][w] = incl if incl > dp[i - 1][w] else dp[i - 1][w]
        else:
            dp[i][w] = dp[i - 1][w]
end = time.time() * 1000
print(f"Max: {dp[n][capacity]}")
print(f"Time: {end - start:.0f}ms")

