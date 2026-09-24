function f3(i) {
    if (i % 7 === 0) throw "boom";
    return i * 2;
}
function f2(i) { return f3(i); }
function f1(i) { return f2(i); }

const N = 200000;
let acc = 0, caught = 0;
const start = Date.now();
for (let i = 1; i <= N; i++) {
    try { acc = (acc + f1(i)) % 1000003; }
    catch (e) { caught++; }
}
const end = Date.now();
console.log("Result: " + acc + "_" + caught);
console.log("Time: " + Math.floor(end - start) + "ms");
