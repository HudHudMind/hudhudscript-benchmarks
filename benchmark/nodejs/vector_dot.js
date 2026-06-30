const a = [];
const b = [];
for (let i = 0; i < 500000; i = i + 1) {
    a.push(i + 1);
    b.push(i + 2);
}
let sum = 0n;
const start = Date.now();
for (let i = 0; i < 500000; i = i + 1) {
    sum = sum + BigInt(a[i]) * BigInt(b[i]);
}
const end = Date.now();
console.log(`Dot: ${sum}`);
console.log(`Time: ${end - start}ms`);
