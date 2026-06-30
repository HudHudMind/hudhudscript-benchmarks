const start = Date.now();
function fib(n) {
    if (n <= 1) return BigInt(n);
    let a = 0n;
    let b = 1n;
    for (let i = 2; i <= n; i++) {
        const temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}
let s = 0n;
for (let i = 0; i < 10000; i++) {
    s = s + fib(1000);
}
const end = Date.now();
console.log(`Sum: ${s}`);
console.log(`Time: ${end - start}ms`);

