const n = 200000;
let seed = 12345;
function ri(m) {
    seed = (seed * 16807) % 2147483647;
    return seed % m;
}

let arr = [];
for (let i = 0; i < n; i++) arr.push(ri(1000000));

const start = Date.now();

const buckets = new Array(10);
let output = new Array(n);

for (let p = 0; p < 6; p++) {
    for (let i = 0; i < 10; i++) buckets[i] = 0;
    const div = Math.pow(10, p);
    for (let i = 0; i < n; i++) {
        const d = Math.floor(arr[i] / div) % 10;
        buckets[d]++;
    }
    for (let i = 1; i < 10; i++) buckets[i] += buckets[i - 1];
    for (let i = n - 1; i >= 0; i--) {
        const d = Math.floor(arr[i] / div) % 10;
        buckets[d]--;
        output[buckets[d]] = arr[i];
    }
    [arr, output] = [output, arr];
}

let c = 0;
for (let i = 0; i < n; i++) c = (c + arr[i] * (i % 7)) % 1000003;

const end = Date.now();
console.log(`Result: ${arr[0]}/${arr[n-1]}_${c}`);
console.log(`Time: ${end - start}ms`);
