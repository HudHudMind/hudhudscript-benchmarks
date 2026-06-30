import time
s1 = "abcdefghij" * 10
s2 = "acegikmoqs" * 10
start = time.time() * 1000
m, n = len(s1), len(s2)
dp = [[0] * (n + 1) for _ in range(m + 1)]
for i in range(1, m + 1):
    for j in range(1, n + 1):
        if s1[i - 1] == s2[j - 1]:
            dp[i][j] = dp[i - 1][j - 1] + 1
        else:
            a = dp[i - 1][j]
            b = dp[i][j - 1]
            dp[i][j] = a if a > b else b
end = time.time() * 1000
print(f"LCS: {dp[m][n]}")
print(f"Time: {end - start:.0f}ms")

