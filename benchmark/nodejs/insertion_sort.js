const start = Date.now();
const arr = [];
for (let i = 1000; i > 0; i--) arr.push(i);
for (let j = 1; j < arr.length; j++) {
    const key = arr[j];
    let k = j - 1;
    while (k >= 0 && arr[k] > key) {
        arr[k + 1] = arr[k];
        k--;
    }
    arr[k + 1] = key;
}
const end = Date.now();
console.log(`First: ${arr[0]}`);
console.log(`Last: ${arr[arr.length - 1]}`);
console.log(`Time: ${end - start}ms`);

