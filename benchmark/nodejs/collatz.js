const start = Date.now();
let maxSteps = 0;
let maxN = 0;
for (let n = 1; n <= 10000; n++) {
    let steps = 0;
    let current = n;
    while (current !== 1) {
        if (current % 2 === 0) {
            current = Math.floor(current / 2);
        } else {
            current = current * 3 + 1;
        }
        steps++;
    }
    if (steps > maxSteps) {
        maxSteps = steps;
        maxN = n;
    }
}
const end = Date.now();
console.log(`Max steps: ${maxSteps} at n=${maxN}`);
console.log(`Time: ${end - start}ms`);

