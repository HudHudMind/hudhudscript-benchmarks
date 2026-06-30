const n = 100000;
const arr = [];
for (let i = 1; i <= n; i++) {
    arr.push(i);
}
const start = Date.now();
const cum = [];
let s = 0;
for (let i = 0; i < n; i++) {
    s = s + arr[i];
    cum.push(s);
}
const end = Date.now();
console.log(`Last: ${cum[n - 1]}`);
console.log(`Time: ${end - start}ms`);

