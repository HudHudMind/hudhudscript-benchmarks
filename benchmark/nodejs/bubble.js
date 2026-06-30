const n = 500;
const arr = [];
for (let i = n; i > 0; i--) {
    arr.push(i);
}
const start = Date.now();
for (let k = 0; k < n; k++) {
    for (let j = 0; j < n - 1; j++) {
        if (arr[j] > arr[j + 1]) {
            const temp = arr[j];
            arr[j] = arr[j + 1];
            arr[j + 1] = temp;
        }
    }
}
const end = Date.now();
console.log(`First: ${arr[0]}`);
console.log(`Last: ${arr[n - 1]}`);
console.log(`Time: ${end - start}ms`);

