const start = Date.now();
const coeffs = [];
for (let i = 0; i <= 1000; i++) coeffs.push(i + 1);
function horner(coeffs, x) {
    let result = coeffs[coeffs.length - 1];
    for (let i = coeffs.length - 2; i >= 0; i--) {
        result = result * x + coeffs[i];
    }
    return result;
}
let s = 0;
for (let i = 0; i < 100000; i++) {
    s += horner(coeffs, 1.5);
}
const end = Date.now();
console.log(`Sum: ${s}`);
console.log(`Time: ${end - start}ms`);

