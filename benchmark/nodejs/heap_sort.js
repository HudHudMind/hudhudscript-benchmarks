const start = Date.now();
const arr = [];
for (let i = 1000; i > 0; i--) arr.push(i);
function heapify(n, idx) {
    let largest = idx;
    const left = 2 * idx + 1;
    const right = 2 * idx + 2;
    if (left < n && arr[left] > arr[largest]) largest = left;
    if (right < n && arr[right] > arr[largest]) largest = right;
    if (largest !== idx) {
        [arr[idx], arr[largest]] = [arr[largest], arr[idx]];
        heapify(n, largest);
    }
}
const n = arr.length;
for (let j = Math.floor(n / 2) - 1; j >= 0; j--) heapify(n, j);
for (let k = n - 1; k > 0; k--) {
    [arr[0], arr[k]] = [arr[k], arr[0]];
    heapify(k, 0);
}
const end = Date.now();
console.log(`First: ${arr[0]}`);
console.log(`Last: ${arr[arr.length - 1]}`);
console.log(`Time: ${end - start}ms`);

