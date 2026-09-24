const base = [];
for (let i = 0; i < 1000; i++) base.push(i);
const R = 2000;
let acc = 0;
const start = Date.now();
for (let r = 0; r < R; r++) {
    const d = base.map(x => x * 2 + 1);
    const f = d.filter(x => x % 3 !== 0);
    const s = f.reduce((a, x) => a + x, 0);
    acc = (acc + s + f.length) % 1000003;
}
const end = Date.now();
console.log("Result: " + acc);
console.log("Time: " + Math.floor(end - start) + "ms");
