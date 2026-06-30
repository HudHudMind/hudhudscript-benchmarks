const start = Date.now();
const weights = Array.from({ length: 50 }, (_, i) => (i * 7 + 3) % 20 + 1);
const values = Array.from({ length: 50 }, (_, i) => (i * 13 + 5) % 50 + 10);
const capacity = 100;
const n = weights.length;
const dp = Array.from({ length: n + 1 }, () => Array(capacity + 1).fill(0));
for (let i = 1; i <= n; i++) {
    for (let w = 0; w <= capacity; w++) {
        if (weights[i - 1] <= w) {
            const incl = values[i - 1] + dp[i - 1][w - weights[i - 1]];
            dp[i][w] = incl > dp[i - 1][w] ? incl : dp[i - 1][w];
        } else {
            dp[i][w] = dp[i - 1][w];
        }
    }
}
const end = Date.now();
console.log(`Max: ${dp[n][capacity]}`);
console.log(`Time: ${end - start}ms`);

