const limit = 10000;
const sieve = new Array(limit + 1).fill(true);
sieve[0] = sieve[1] = false;
const start = Date.now();
for (let p = 2; p * p <= limit; p++) {
    if (sieve[p]) {
        for (let m = p * p; m <= limit; m += p) {
            sieve[m] = false;
        }
    }
}
let count = 0;
for (let i = 2; i <= limit; i++) {
    if (sieve[i]) count++;
}
const end = Date.now();
console.log(`Primes up to 10000: ${count}`);
console.log(`Time: ${end - start}ms`);

