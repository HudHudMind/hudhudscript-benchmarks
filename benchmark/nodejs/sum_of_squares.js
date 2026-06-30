let sum = 0n;
const start = Date.now();
for (let i = 1; i <= 1000000; i = i + 1) {
    sum = sum + BigInt(i) * BigInt(i);
}
const end = Date.now();
console.log(`Sum: ${sum}`);
console.log(`Time: ${end - start}ms`);
