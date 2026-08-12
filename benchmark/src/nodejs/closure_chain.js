function makeCounter(start) {
    let c = start;
    return function() {
        c = c + 1;
        return c;
    };
}

const N = 150000;
let acc = 0;
const start = Date.now();
for (let i = 0; i < N; i++) {
    const ctr = makeCounter(i % 1000);
    acc = (acc + ctr() + ctr() + ctr()) % 1000003;
}
const end = Date.now();
console.log("Result: " + acc);
console.log("Time: " + Math.floor(end - start) + "ms");
