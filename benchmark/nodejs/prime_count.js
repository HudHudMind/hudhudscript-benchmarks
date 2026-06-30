const start = Date.now();
let count = 0;
for (let n = 2; n <= 100000; n++) {
    let is_p = true;
    if (n < 2) is_p = false;
    else if (n === 2) is_p = true;
    else if (n % 2 === 0) is_p = false;
    else {
        for (let i = 3; i * i <= n; i += 2) {
            if (n % i === 0) {
                is_p = false;
                break;
            }
        }
    }
    if (is_p) count++;
}
const end = Date.now();
console.log(`Primes: ${count}`);
console.log(`Time: ${end - start}ms`);

