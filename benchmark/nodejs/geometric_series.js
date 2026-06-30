const start = Date.now();
const r = 0.999;
let s = 0.0;
let term = 1.0;
for (let i = 0; i < 1000000; i++) {
    s += term;
    term *= r;
}
const end = Date.now();
console.log(`Sum: ${s}`);
console.log(`Time: ${end - start}ms`);

