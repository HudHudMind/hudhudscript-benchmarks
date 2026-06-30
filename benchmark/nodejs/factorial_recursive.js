const start = Date.now();
function fact(n) {
    if (n <= 1) return 1n;
    return BigInt(n) * fact(n - 1);
}
const result = fact(150);
const end = Date.now();
console.log(`fact(150) = ${result}`);
console.log(`Time: ${end - start}ms`);

