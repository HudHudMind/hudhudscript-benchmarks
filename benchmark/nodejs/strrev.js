const start = Date.now();
const s = "a".repeat(50000);
let rev = "";
for (let j = s.length - 1; j >= 0; j--) {
    rev += s[j];
}
const end = Date.now();
console.log(`Len: ${rev.length}`);
console.log(`Time: ${end - start}ms`);

