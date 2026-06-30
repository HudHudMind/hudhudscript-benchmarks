const start = Date.now();
let result = 1n;
for (let i = 2n; i <= 10000n; i++) {
    result *= i;
}
const end = Date.now();
console.log("Result: " + result);
console.log(`Time: ${end - start}ms`);
