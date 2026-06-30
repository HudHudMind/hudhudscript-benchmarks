let s = "";
const start = Date.now();
for (let i = 0; i < 50000; i = i + 1) {
    s = s + "x";
}
const end = Date.now();
console.log(`Length: ${s.length}`);
console.log(`Time: ${end - start}ms`);
