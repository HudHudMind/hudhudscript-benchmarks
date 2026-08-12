const N = 500000;
let acc = 0;
const start = Date.now();
for (let i = 0; i < N; i++) {
    const p = { x: i, y: i * 2, z: 0 };
    p.z = p.x + p.y;
    acc = (acc + p.z) % 1000003;
}
const end = Date.now();
console.log("Result: " + acc);
console.log("Time: " + Math.floor(end - start) + "ms");
