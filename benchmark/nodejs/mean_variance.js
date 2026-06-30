const start = Date.now();
const arr = [];
for (let i = 1; i <= 1000000; i++) arr.push(i);
let s = 0;
for (let i = 0; i < arr.length; i++) s += arr[i];
const mean = s / arr.length;
let sq_diff = 0;
for (let i = 0; i < arr.length; i++) {
    const diff = arr[i] - mean;
    sq_diff += diff * diff;
}
const variance = sq_diff / arr.length;
const end = Date.now();
console.log(`Mean: ${mean}`);
console.log(`Variance: ${variance}`);
console.log(`Time: ${end - start}ms`);

