const arr = [];
for (let i = 1; i <= 1000000; i++) arr.push(i);
let s = 0;
const start = Date.now();
for (let i = 0; i < arr.length; i++) s += arr[i];
const mean = s / arr.length;
let sq_diff = 0;
for (let i = 0; i < arr.length; i++) {
    const diff = arr[i] - mean;
    sq_diff += diff * diff;
}
const variance = sq_diff / arr.length;
const end = Date.now();
console.log(`Result: ${mean.toFixed(1)}/${variance.toFixed(1)}`);
console.log(`Time: ${end - start}ms`);

