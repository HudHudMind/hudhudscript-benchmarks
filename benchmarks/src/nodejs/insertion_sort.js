const arr = [];
for (let i = 1000; i > 0; i--) arr.push(i);
const start = Date.now();
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
console.log(`Result: ${arr[0]}/${arr[arr.length - 1]}`);
;
console.log(`Time: ${end - start}ms`);

