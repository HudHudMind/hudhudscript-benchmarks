function power(base, exp) {
    let result = 1n;
    const b = BigInt(base);
    for (let i = 0; i < exp; i = i + 1) {
        result = result * b;
    }
    return result;
}

let sum = 0n;
const start = Date.now();
for (let i = 0; i < 10000; i = i + 1) {
    sum = sum + power(2, 1000);
}
const end = Date.now();
console.log(`Sum: ${sum}`);
console.log(`Time: ${end - start}ms`);
