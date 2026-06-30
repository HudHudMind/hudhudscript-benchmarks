const start = Date.now();
function fib(n, memo) {
    if (n <= 1) return BigInt(n);
    if (memo[n] !== null) return memo[n];
    memo[n] = fib(n - 1, memo) + fib(n - 2, memo);
    return memo[n];
}
let s = 0n;
for (let i = 0; i < 10000; i++) {
    const memo = new Array(501).fill(null);
    s += fib(500, memo);
}
const end = Date.now();
console.log(`Sum: ${s}`);
console.log(`Time: ${end - start}ms`);

