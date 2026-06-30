const start = Date.now();
const s1 = "abcdefghij".repeat(10);
const s2 = "acegikmoqs".repeat(10);
const m = s1.length, n = s2.length;
const dp = Array.from({ length: m + 1 }, () => Array(n + 1).fill(0));
for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
        if (s1[i - 1] === s2[j - 1]) dp[i][j] = dp[i - 1][j - 1] + 1;
        else {
            const a = dp[i - 1][j];
            const b = dp[i][j - 1];
            dp[i][j] = a > b ? a : b;
        }
    }
}
const end = Date.now();
console.log(`LCS: ${dp[m][n]}`);
console.log(`Time: ${end - start}ms`);

