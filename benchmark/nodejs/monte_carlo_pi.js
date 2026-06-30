let inside = 0;
const total = 500000;
let seed = 12345n;
function next_random() {
    seed = (seed * 16807n) % 2147483647n;
    return Number(seed) / 2147483647.0;
}
const start = Date.now();
for (let i = 0; i < total; i++) {
    const x = next_random();
    const y = next_random();
    if (x * x + y * y <= 1.0) {
        inside++;
    }
}
const end = Date.now();
const pi = 4.0 * inside / total;
console.log(`Pi: ${pi}`);
console.log(`Time: ${end - start}ms`);
