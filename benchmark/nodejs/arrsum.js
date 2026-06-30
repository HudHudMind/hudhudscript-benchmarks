const arr = [];
for (let i = 0; i < 10000; i = i + 1) {
    arr.push(i);
}
let sum = 0;
const start = Date.now();
for (let i = 0; i < 10000; i = i + 1) {
    sum = sum + arr[i];
}
const end = Date.now();
console.log(`Sum: ${sum}`);
console.log(`Time: ${end - start}ms`);
