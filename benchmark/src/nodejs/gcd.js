const start = Date.now();
function gcd(a, b) {
    while (b !== 0) {
        const temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}
let result = 0;
for (let i = 1; i <= 10000; i++) {
    result = gcd(i * 12345, i * 6789 + 1);
}
const end = Date.now();
console.log(`Result: ${result}`);
console.log(`Time: ${end - start}ms`);

