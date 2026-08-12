function isPrime(n) {
    if (n < 2) return false;
    if (n === 2) return true;
    if (n % 2 === 0) return false;
    for (let i = 3; i * i <= n; i += 2) {
        if (n % i === 0) return false;
    }
    return true;
}

const start = Date.now();
let count = 0;
for (let n = 2; n <= 100000; n++) {
    if (isPrime(n)) count++;
}
const end = Date.now();
console.log(`Result: ${count}`);
console.log(`Time: ${end - start}ms`);
