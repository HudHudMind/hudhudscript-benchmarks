const start = Date.now();
const arr = [];
for (let i = 0; i < 100000; i++) {
    arr.push(i * 2);
}
let found = 0;
for (let j = 0; j < 10000; j++) {
    const target = j * 20;
    let left = 0;
    let right = 99999;
    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (arr[mid] === target) {
            found++;
            break;
        }
        if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
}
const end = Date.now();
console.log(`Found: ${found}`);
console.log(`Time: ${end - start}ms`);

