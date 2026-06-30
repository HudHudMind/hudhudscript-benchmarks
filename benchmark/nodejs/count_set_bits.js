const start = Date.now();
let total = 0;
for (let n = 1; n <= 100000; n++) {
    let x = n;
    while (x > 0.5) {
        if (x % 2 >= 1) {
            total++;
        }
        x = x / 2;
    }
}
const end = Date.now();
console.log(`Total: ${total}`);
console.log(`Time: ${end - start}ms`);

