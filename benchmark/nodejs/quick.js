const start = Date.now();
const arr = [];
for (let i = 1000; i > 0; i--) arr.push(i);
const stack = [0, arr.length - 1];
while (stack.length > 0) {
    const high = stack.pop();
    const low = stack.pop();
    if (low < high) {
        const pivot = arr[high];
        let pi = low - 1;
        for (let j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                pi++;
                [arr[pi], arr[j]] = [arr[j], arr[pi]];
            }
        }
        pi++;
        [arr[pi], arr[high]] = [arr[high], arr[pi]];
        if (pi - 1 > low) {
            stack.push(low);
            stack.push(pi - 1);
        }
        if (pi + 1 < high) {
            stack.push(pi + 1);
            stack.push(high);
        }
    }
}
const end = Date.now();
console.log(`First: ${arr[0]}`);
console.log(`Last: ${arr[arr.length - 1]}`);
console.log(`Time: ${end - start}ms`);

